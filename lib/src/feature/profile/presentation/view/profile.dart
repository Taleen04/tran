import 'dart:developer';
import 'dart:io';
import 'package:ai_transport/main.dart';
import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_gradients.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:ai_transport/src/feature/profile/data/data_source/edit_profile_data_source.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/widgets/card_logout.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/widgets/card_profile.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/wallet_provider.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_data_profile_bloc/get_user_profile_bloc.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_data_profile_bloc/get_user_profile_event.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_data_profile_bloc/get_user_profile_state.dart';
import 'package:ai_transport/src/feature/profile/repo/edit_profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _profileImageFile;
  final ImagePicker _picker = ImagePicker();
  final EditProfileRepository _photoRepo = EditProfileRepository(
    EditProfileDataSource(),
  );

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    final token = SharedPrefHelper.getString(StorageKeys.token);
    if (token.isNotEmpty) {
      context.read<GetUserProfileBloc>().add(FetchUserProfile());
    } else {
      context.go('/');
    }
  }

  // بناء URL كامل للصورة
  String _buildImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';

    // إذا كان المسار يحتوي على URL كامل، استخدمه مباشرة
    if (imageUrl.startsWith('http')) {
      return imageUrl;
    }

    // إذا كان المسار نسبي، أضف البادئة
    const baseUrl = 'https://parking.engmahmoudali.com/storage/';
    if (imageUrl.startsWith('storage/')) {
      return '$baseUrl$imageUrl';
    }

    // إذا لم تكن البادئة موجودة، أضفها
    return '$baseUrl$imageUrl';
  }

  // اختيار صورة
  Future<void> _pickAndUploadProfilePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final File imageFile = File(image.path);
        setState(() => _profileImageFile = imageFile);

        // رفع الصورة
        _uploadProfilePhoto(imageFile);
      }
    } catch (e) {
      log('خطأ في اختيار صورة البروفايل: $e');
      if (mounted) {
        _showErrorSnackBar(
          'خطأ في اختيار صورة البروفايل. تأكد من إعطاء التطبيق صلاحية الوصول للصور.',
        );
      }
    }
  }

  Future<void> _uploadProfilePhoto(File imageFile) async {
    try {
      final result = await _photoRepo.uploadProfilePhoto(imageFile);

      if (result['success']) {
        _showSuccessSnackBar(result['message']);
        _loadUserProfile(); // تحديث البروفايل
      } else {
        _showErrorSnackBar(result['error']);
      }
    } catch (e) {
      _showErrorSnackBar('خطأ في رفع صورة البروفايل: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<GetUserProfileBloc, GetUserProfileState>(
          listener: (context, state) async {
            if (state is GetUserProfileFailure) {
              if (state.error.contains("401") ||
                  state.error.contains("unauthorized")) {
                await SharedPrefHelper.removeData(StorageKeys.token);
                context.go('/');
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            }
          },
          builder: (context, state) {
            if (state is GetUserProfileInitial ||
                state is GetUserProfileLoading) {
              return Container(
                color: AppColors.background,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Column(
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFFFA726),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'جاري تحميل البيانات...',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is GetUserProfileSuccess) {
              final user = state.userProfile;
              final String photoUrl = user.photo ?? "";

              return Container(
                color: AppColors.background,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Header Container with Gradient
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: AppGradients.orangeGradient,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Action Buttons Row
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildActionButton(
                                    icon: Icons.edit,
                                    onPressed: () async {
                                      await context.push(
                                        '/editProfile',
                                        extra: user,
                                      );
                                      _loadUserProfile();
                                    },
                                  ),
                                  _buildActionButton(
                                    icon: Icons.notifications,
                                    onPressed: () {
                                      context.push("/notifications");
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Profile Image Section
                            _buildProfileImageSection(photoUrl),

                            const SizedBox(height: 15),

                            // User Info Section
                            _buildUserInfoSection(user),

                            const SizedBox(height: 25),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Profile Cards Section
                      _buildProfileCardsSection(user),
                    ],
                  ),
                ),
              );
            } else if (state is GetUserProfileFailure) {
              return Container(
                color: AppColors.background,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 50),
                        SizedBox(height: 15),
                        Text(
                          "فشل تحميل الملف الشخصي",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.backGroundPrimary, size: 28),
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildProfileImageSection(String photoUrl) {
    return GestureDetector(
      onTap: _pickAndUploadProfilePhoto,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.3),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child:
                    _profileImageFile != null
                        ? ClipOval(
                          child: Image.file(
                            _profileImageFile!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                        : (photoUrl.isNotEmpty)
                        ? ClipOval(
                          child: Image.network(
                            _buildImageUrl(photoUrl),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 70,
                                color: Color(0xFFFFA726),
                              );
                            },
                          ),
                        )
                        : const Icon(
                          Icons.person,
                          size: 70,
                          color: Color(0xFFFFA726),
                        ),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Color(0xFFFFA726),
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(user) {
    return Column(
      children: [
        Text(
          user.name.toString(),
          style: AppTextStyling.font14W500TextInter.copyWith(
            color: AppColors.textWhite,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Text(
            user.serviceType,
            style: AppTextStyling.font14W500TextInter.copyWith(
              color: AppColors.textWhite,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: AppColors.textWhite, size: 18),
              const SizedBox(width: 6),
              Text(
                user.rating,
                style: AppTextStyling.font14W500TextInter.copyWith(
                  color: AppColors.textWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCardsSection(user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Personal Information Card
          _buildModernCard(
            Directionality(
              textDirection: TextDirection.ltr,
              child: CardProfile(
                title: AppLocalizations.of(context)!.personalInformation,
                icon: Icons.contact_phone,
                visible: 1,
                rows: [
                  {
                    'icon': Icons.phone,
                    'label': AppLocalizations.of(context)!.phoneNumber,
                    'value': user.phone,
                  },
                  {
                    'icon': Icons.email,
                    'label': AppLocalizations.of(context)!.email,
                    'value': user.email ?? '-',
                  },
                  {
                    'icon': Icons.location_on,
                    'label': AppLocalizations.of(context)!.address,
                    'value': user.address,
                  },
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Calendar Card
          // _buildModernCard(
          //   GestureDetector(
          //     onTap: () {
          //       context.push('/calender');
          //     },
          //     child: Container(
          //       padding: const EdgeInsets.all(20),
          //       child: Row(
          //         children: [
          //           Container(
          //             padding: const EdgeInsets.all(15),
          //             decoration: BoxDecoration(
          //               gradient: AppGradients.orangeGradient,
          //               borderRadius: BorderRadius.circular(15),
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: const Color(0xFFFFA726).withOpacity(0.3),
          //                   blurRadius: 10,
          //                   offset: const Offset(0, 5),
          //                 ),
          //               ],
          //             ),
          //             child: const Icon(
          //               Icons.calendar_today,
          //               color: Colors.white,
          //               size: 28,
          //             ),
          //           ),
          //           const SizedBox(width: 20),
          //           Expanded(
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   'التقويم',
          //                   style: AppTextStyling.font14W500TextInter.copyWith(
          //                     color: Colors.white,
          //                     fontSize: 18,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 const SizedBox(height: 5),
          //                 Text(
          //                   'عرض المواعيد والجدولة',
          //                   style: AppTextStyling.font14W500TextInter.copyWith(
          //                     color: Colors.white.withOpacity(0.8),
          //                     fontSize: 14,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Container(
          //             padding: const EdgeInsets.all(8),
          //             decoration: BoxDecoration(
          //               color: Colors.white.withOpacity(0.2),
          //               borderRadius: BorderRadius.circular(10),
          //             ),
          //             child: const Icon(
          //               Icons.arrow_forward_ios,
          //               color: Colors.white,
          //               size: 16,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          const SizedBox(height: 20),

          // Wallet Card
          _buildModernCard(
            Directionality(
              textDirection: TextDirection.ltr,
              child: CardProfile(
                title: AppLocalizations.of(context)!.Wallet,
                icon: Icons.account_balance_wallet,
                visible: 1,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WalletProvider(),
                    ),
                  );
                },
                rows: [
                  {
                    'icon': Icons.monetization_on,
                    'label': AppLocalizations.of(context)!.CurrentBalance,
                    'value': AppLocalizations.of(context)!.ShowDetails,
                  },
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Documents Card
          _buildModernCard(
            Directionality(
              textDirection: TextDirection.ltr,
              child: CardProfile(
                title: AppLocalizations.of(context)!.Documents,
                icon: Icons.document_scanner_outlined,
                visible: 2,
                rows: [
                  {
                    'icon': Icons.credit_card,
                    'label': AppLocalizations.of(context)!.Id,
                    'value': _getDocumentStatus(user.identityImage),
                  },
                  {
                    'icon': Icons.assignment_turned_in,
                    'label':
                        AppLocalizations.of(
                          context,
                        )!.CertificateOfNoCriminalRecord,
                    'value': _getDocumentStatus(user.nonConvictionCertificate),
                  },
                  {
                    'icon': Icons.car_crash_outlined,
                    'label': AppLocalizations.of(context)!.VehicleLicense,
                    'value': _getDocumentStatus(user.licenseImage),
                  },
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Settings Card
          _buildModernCard(
            Directionality(
              textDirection: TextDirection.ltr,
              child: SettingsCard(
                token: SharedPrefHelper.getString(StorageKeys.token),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildModernCard(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  // دالة لتحديد حالة الوثيقة
  String _getDocumentStatus(dynamic documentData) {
    if (documentData == null ||
        documentData.toString().isEmpty ||
        documentData.toString() == 'null') {
      return 'غير مرفوعة';
    }
    return 'مرفوعة';
  }
}
