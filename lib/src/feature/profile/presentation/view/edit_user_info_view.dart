import 'dart:developer';
import 'dart:io';
import 'package:ai_transport/l10n/app_localizations.dart';
import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/constants/font_weight_helper.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:ai_transport/src/core/utils/map_helper.dart';
import 'package:ai_transport/src/feature/profile/domain/entity/profile_entity.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/edit_profile_bloc/edit_profile_event.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/edit_profile_bloc/edit_profile_state.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_data_profile_bloc/get_user_profile_bloc.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_data_profile_bloc/get_user_profile_event.dart';
import 'package:ai_transport/src/feature/profile/repo/edit_profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  final StaffProfileEntity user;
  final EditProfileRepository repository;
  final VoidCallback? onProfileUpdated;

  const EditProfileView({
    super.key,
    required this.user,
    required this.repository,
    this.onProfileUpdated,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  final _formKey = GlobalKey<FormState>();

  File? _idCardImageFile;
  File? _ungovernedImageFile;
  File? _carLicenseFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
    addressController = TextEditingController(text: widget.user.address);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  String _buildImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    const baseUrl = 'https://parking.engmahmoudali.com/storage/';
    return imageUrl.startsWith('storage/')
        ? '$baseUrl$imageUrl'
        : '$baseUrl$imageUrl';
  }

  Future<void> _pickAndUploadImage({
    required File? imageFile,
    required Future<Map<String, dynamic>> Function(File) uploadFunction,
    required void Function(File) setImageFile,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final File file = File(image.path);
        setState(() => setImageFile(file));

        final result = await uploadFunction(file);
        if (result['success']) {
          if (mounted && widget.onProfileUpdated != null)
            widget.onProfileUpdated!();
        } else {
          _showErrorSnackBar(result['error']);
        }
      }
    } catch (e) {
      log('خطأ في اختيار الصورة: $e');
      _showErrorSnackBar(
        'خطأ في اختيار الصورة. تأكد من إعطاء التطبيق صلاحية الوصول للصور.',
      );
    }
  }

  void _showErrorSnackBar(String? message) {
    if (message == null || message.isEmpty) return;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _getCurrentLocationAndUpdateAddress() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final position = await MapHelper.getCurrentLocation();
      final address = await MapHelper.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (mounted) Navigator.pop(context);
      addressController.text = address;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث العنوان بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showErrorSnackBar('خطأ في الحصول على الموقع: $e');
    }
  }

  bool _validateEmail(String? email) {
    if (email == null || email.isEmpty) return true; // اختياري
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileBloc(widget.repository),
      child: BlocListener<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            context.read<GetUserProfileBloc>().add(FetchUserProfile());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تعديل البيانات بنجاح'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) context.pop();
            });
          } else if (state is EditProfileFailure) {
            _showErrorSnackBar('فشل في تحديث البيانات: ${state.error}');
          }
        },
        child: BlocBuilder<EditProfileBloc, EditProfileState>(
          builder: (context, state) {
            Color borderColor;
            bool buttonEnabled = true;

            if (state is EditProfileLoading) {
              borderColor = Colors.grey;
              buttonEnabled = false;
            } else if (state is EditProfileSuccess) {
              borderColor = Colors.green;
            } else if (state is EditProfileFailure) {
              borderColor = Colors.red;
            } else {
              borderColor = AppColors.orange;
            }

            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.orange,
                centerTitle: true,
                title: Text(
                AppLocalizations.of(context)!.updateProfile,
                  style: AppTextStyling.font14W500TextInter.copyWith(
                    fontWeight: FontWeightHelper.medium,
                  ),
                ),
              ),
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildTextField(
                        AppLocalizations.of(context)!.name,
                        nameController,
                        borderColor,
                        requiredField: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        AppLocalizations.of(context)!.email,
                        emailController,
                        borderColor,
                        emailField: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                         AppLocalizations.of(context)!.phoneNumber,
                        phoneController,
                        borderColor,
                        requiredField: true,
                        phoneField: true,
                      ),
                      const SizedBox(height: 16),
                      _buildAddressField(
                        AppLocalizations.of(context)!.address,
                        addressController,
                        borderColor,
                      ),
                      const SizedBox(height: 30),
                      _buildImageSection(
                        AppLocalizations.of(context)!.Id,
                        _idCardImageFile,
                        widget.user.identityImage,
                        Icons.credit_card,
                        () => _pickAndUploadImage(
                          imageFile: _idCardImageFile,
                          uploadFunction: widget.repository.uploadIdCard,
                          setImageFile: (file) => _idCardImageFile = file,
                        ),
                      ),
                      _buildImageSection(
                         AppLocalizations.of(context)!.CertificateOfNoCriminalRecord,
                        _ungovernedImageFile,
                        widget.user.nonConvictionCertificate,
                        Icons.description,
                        () => _pickAndUploadImage(
                          imageFile: _ungovernedImageFile,
                          uploadFunction: widget.repository.uploadUngoverned,
                          setImageFile: (file) => _ungovernedImageFile = file,
                        ),
                      ),
                      _buildImageSection(
                         AppLocalizations.of(context)!.VehicleLicense,
                        _carLicenseFile,
                        widget.user.licenseImage,
                        Icons.credit_card,
                        () => _pickAndUploadImage(
                          imageFile: _carLicenseFile,
                          uploadFunction: widget.repository.uploadCarLicense,
                          setImageFile: (file) => _carLicenseFile = file,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                buttonEnabled ? AppColors.orange : Colors.grey,
                          ),
                          onPressed:
                              buttonEnabled
                                  ? () {
                                    if (!_formKey.currentState!.validate())
                                      return;

                                    final updatedUser = widget.user.copyWith(
                                      name: nameController.text.trim(),
                                      email:
                                          emailController.text.trim().isNotEmpty
                                              ? emailController.text.trim()
                                              : null,
                                      phone: phoneController.text.trim(),
                                      address: addressController.text.trim(),
                                    );

                                    context.read<EditProfileBloc>().add(
                                      UpdateProfile(updatedUser),
                                    );
                                  }
                                  : null,
                          child:
                              state is EditProfileLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : Text(
                                     AppLocalizations.of(context)!.save,
                                    style: AppTextStyling.font14W500TextInter
                                        .copyWith(
                                          fontWeight: FontWeightHelper.bold,
                                        ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    Color borderColor, {
    bool requiredField = false,
    bool emailField = false,
    bool phoneField = false,
  }) {
    return TextFormField(
      controller: controller,
      style: AppTextStyling.font14W500TextInter.copyWith(
        fontWeight: FontWeightHelper.medium,
      ),
      validator: (value) {
        if (requiredField && (value == null || value.trim().isEmpty))
          return 'يرجى إدخال $label';
        if (emailField &&
            value != null &&
            value.isNotEmpty &&
            !_validateEmail(value))
          return 'يرجى إدخال بريد إلكتروني صحيح';
        if (phoneField && value != null && value.trim().length < 10)
          return 'رقم الجوال يجب أن لا يقل عن 10 أرقام';
        return null;
      },
      keyboardType: phoneField ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.backGroundIcon),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }

  Widget _buildAddressField(
    String label,
    TextEditingController controller,
    Color borderColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2D3748).withOpacity(0.8),
            Color(0xFF1A202C).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: _getCurrentLocationAndUpdateAddress,
              icon: const Icon(
                Icons.my_location_rounded,
                color: Colors.white,
                size: 20,
              ),
              tooltip: 'الحصول على الموقع الحالي',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(
    String title,
    File? localImage,
    String? serverImage,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2D3748).withOpacity(0.8),
            Color(0xFF1A202C).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child:
                    localImage != null
                        ? Image.file(localImage, fit: BoxFit.cover)
                        : serverImage != null && serverImage.isNotEmpty
                        ? Image.network(
                          _buildImageUrl(serverImage),
                          fit: BoxFit.cover,
                        )
                        : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF2D3748).withOpacity(0.5),
                                Color(0xFF1A202C).withOpacity(0.5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.add_photo_alternate_rounded,
                                  color: Colors.white54,
                                  size: 40,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'اضغط لرفع الصورة',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
