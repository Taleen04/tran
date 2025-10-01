import 'dart:io';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/feature/home/domain/entities/cancel_request_entity.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/cancel_request_bloc/cancel_request_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/need_van_bloc/need_van_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/need_van_bloc/need_van_event.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/need_van_bloc/need_van_state.dart';
import 'package:ai_transport/src/feature/home/data/models/need_van_request_model.dart';
import 'package:ai_transport/src/feature/home/repository/need_van_repository.dart';
import 'package:ai_transport/src/feature/home/data/data_sources/need_van_data_source.dart';

class CancelRequestDialog extends StatefulWidget {
  final int requestId;
  final String requestOrigin;
  final String requestDestination;

  const CancelRequestDialog({
    super.key,
    required this.requestId,
    required this.requestOrigin,
    required this.requestDestination,
  });

  @override
  State<CancelRequestDialog> createState() => _CancelRequestDialogState();
}

class _CancelRequestDialogState extends State<CancelRequestDialog> {
  CancellationReason _selectedReason = CancellationReason.other;
  final TextEditingController _notesController = TextEditingController();
  final List<File> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();
  String? _errorMessage;

  // Need Van variables
  bool _showNeedVanForm = false;
  NeedVanReason _selectedNeedVanReason = NeedVanReason.passengerCountExceeded;
  final TextEditingController _cargoDescriptionController =
      TextEditingController();
  final TextEditingController _needVanNotesController = TextEditingController();
  int _passengerCount = 1;

  @override
  void dispose() {
    _notesController.dispose();
    _cargoDescriptionController.dispose();
    _needVanNotesController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      setState(() {
        _selectedImages.addAll(images.map((xFile) => File(xFile.path)));
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في اختيار الصور: $e')));
    }
  }

  void _submitNeedVanRequest() {
    final needVanRequest = NeedVanRequestModel(
      reason: _selectedNeedVanReason.value,
      cargoDescription:
          _cargoDescriptionController.text.isNotEmpty
              ? _cargoDescriptionController.text
              : null,
      notes:
          _needVanNotesController.text.isNotEmpty
              ? _needVanNotesController.text
              : null,
      passengerCount: _passengerCount,
    );

    context.read<NeedVanBloc>().add(
      RequestNeedVanEvent(
        requestId: widget.requestId,
        needVanRequest: needVanRequest,
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submitCancellation() {
    if (_selectedImages.isEmpty) {
      setState(() {
        _errorMessage = 'يرجى اختيار صورة إثبات واحدة على الأقل';
      });
      return;
    }

    // Clear any previous error
    setState(() {
      _errorMessage = null;
    });

    context.read<CancelRequestBloc>().add(
      CancelRequestSubmitted(
        requestId: widget.requestId,
        evidencePhotos: _selectedImages,
        reason: _selectedReason,
        notes:
            _notesController.text.trim().isNotEmpty
                ? _notesController.text.trim()
                : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CancelRequestBloc, CancelRequestState>(
      listener: (context, state) {
        if (state is CancelRequestSuccess) {
          Navigator.of(context).pop(true); // Return true to indicate success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.response.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is CancelRequestError) {
          setState(() {
            _errorMessage = _parseErrorMessage(state.message);
          });
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.backGroundPrimary,
                      AppColors.backGroundPrimary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: responsiveWidth(context, 12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تعديل طلب النقل',
                            style: AppTextStyling.font14W500TextInter.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: responsiveHeight(context, 4)),
                          Text(
                            'اختر سبب الإلغاء وأرفق الصور المطلوبة',
                            style: AppTextStyling.font14W500TextInter.copyWith(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Error message display
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[600],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTextStyling.font14W500TextInter.copyWith(
                            color: Colors.red[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _errorMessage = null;
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.red[600],
                          size: 18,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Request Info Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.backGroundPrimary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'تفاصيل الطلب',
                                  style: AppTextStyling.font14W500TextInter
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.backGroundPrimary,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: responsiveHeight(context, 12)),
                            Row(
                              children: [
                                Text(
                                  'من:${widget.requestOrigin}',
                                  style: AppTextStyling.font14W500TextInter
                                      .copyWith(
                                        fontSize: 14,
                                        color: AppColors.backGroundIcon,
                                      ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'إلى:${widget.requestDestination}',
                                      style: AppTextStyling.font14W500TextInter
                                          .copyWith(
                                            fontSize: 14,
                                            color: AppColors.backGroundIcon,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Cancellation Reason Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.cancel_outlined,
                                  color: AppColors.backGroundPrimary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'سبب الإلغاء ',
                                  style: AppTextStyling.font14W500TextInter
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.backGroundPrimary,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<CancellationReason>(
                              value: _selectedReason,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.backGroundIcon,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.backGroundIcon,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.backGroundPrimary,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                filled: true,
                                fillColor: AppColors.textPrimary,
                              ),
                              items:
                                  CancellationReason.values.map((reason) {
                                    return DropdownMenuItem(
                                      value: reason,
                                      child: Text(
                                        _getReasonDisplayName(reason),
                                        style: AppTextStyling
                                            .font14W500TextInter
                                            .copyWith(
                                              color: AppColors.backGroundIcon,
                                            ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedReason = value;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Evidence Photos Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.photo_camera,
                                  color: AppColors.backGroundPrimary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'صور الإثبات *',
                                  style: AppTextStyling.font14W500TextInter
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.backGroundPrimary,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Photo picker button
                            Container(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _pickImages,
                                icon: const Icon(Icons.add_a_photo, size: 20),
                                label: const Text('إضافة صور'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.backGroundPrimary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Selected images preview
                            if (_selectedImages.isNotEmpty) ...[
                              Text(
                                'الصور المحددة:',
                                style: AppTextStyling.font14W500TextInter
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _selectedImages.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.file(
                                              _selectedImages[index],
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () => _removeImage(index),
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 4,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Notes Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.note_add,
                                  color: AppColors.backGroundPrimary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'ملاحظات إضافية (اختياري)',
                                  style: AppTextStyling.font14W500TextInter
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.backGroundPrimary,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _notesController,
                              maxLines: 3,
                              maxLength: 500,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.backGroundPrimary,
                                  ),
                                ),
                                hintText: 'أدخل أي تفاصيل إضافية...',
                                hintStyle: AppTextStyling.font14W500TextInter
                                    .copyWith(color: Colors.grey[500]),
                                filled: true,
                                fillColor: Colors.grey[50],
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Need Van Button
              if (!_showNeedVanForm)
                // Container(
                //   width: double.infinity,
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 20,
                //     vertical: 10,
                //   ),
                //   child: ElevatedButton.icon(
                //     onPressed: () {
                //       setState(() {
                //         _showNeedVanForm = true;
                //       });
                //     },
                //     icon: const Icon(Icons.local_shipping, size: 20),
                //     label: const Text('طلب سيارة فان'),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: AppColors.orange,
                //       foregroundColor: Colors.white,
                //       padding: const EdgeInsets.symmetric(vertical: 12),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //     ),
                //   ),
                // ),

              // Need Van Form
              if (_showNeedVanForm) _buildNeedVanForm(),

              // Action buttons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.grey[400]!),
                        ),
                        child: Text(
                          'إلغاء',
                          style: AppTextStyling.font14W500TextInter.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BlocBuilder<CancelRequestBloc, CancelRequestState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed:
                                state is CancelRequestLoading
                                    ? null
                                    : _submitCancellation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.backGroundPrimary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child:
                                state is CancelRequestLoading
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                    : Text(
                                      'تعديل الطلب',
                                      style: AppTextStyling.font14W500TextInter
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getReasonDisplayName(CancellationReason reason) {
    switch (reason) {
      case CancellationReason.clientRefused:
        return 'رفض العميل';
      case CancellationReason.vehicleFailure:
        return 'عطل في المركبة';
      case CancellationReason.unsuitableLuggage:
        return 'حمولة غير مناسبة';
      case CancellationReason.clientNotFound:
        return 'العميل غير موجود';
      case CancellationReason.weatherConditions:
        return 'ظروف الطقس';
      case CancellationReason.other:
        return 'أخرى';
    }
  }

  String _parseErrorMessage(String errorMessage) {
    // Parse specific API error messages
    if (errorMessage.contains('The selected reason is invalid')) {
      return 'سبب الإلغاء المحدد غير صحيح. يرجى اختيار سبب آخر.';
    }

    if (errorMessage.contains('Validation failed')) {
      return 'فشل في التحقق من البيانات. يرجى التحقق من المعلومات المدخلة.';
    }

    if (errorMessage.contains('evidence_photos')) {
      return 'يرجى إرفاق صور الإثبات المطلوبة.';
    }

    if (errorMessage.contains('Connection timeout') ||
        errorMessage.contains('connection timeout')) {
      return 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.';
    }

    if (errorMessage.contains('Network error') ||
        errorMessage.contains('network')) {
      return 'خطأ في الشبكة. يرجى التحقق من اتصال الإنترنت.';
    }

    // Default error message
    return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
  }

  Widget _buildNeedVanForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.orange.withOpacity(0.3)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طلب سيارة فان',
                style: AppTextStyling.font14W500TextInter.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showNeedVanForm = false;
                  });
                },
                icon: const Icon(Icons.close, color: AppColors.orange),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Reason Selection
          Text(
            'سبب الطلب:',
            style: AppTextStyling.font14W500TextInter.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<NeedVanReason>(
            value: _selectedNeedVanReason,
            onChanged: (NeedVanReason? newValue) {
              setState(() {
                _selectedNeedVanReason = newValue!;
              });
            },
            items:
                NeedVanReason.values.map((NeedVanReason reason) {
                  return DropdownMenuItem<NeedVanReason>(
                    value: reason,
                    child: Text(_getNeedVanReasonDisplayName(reason)),
                  );
                }).toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Passenger Count
          Text(
            'عدد الركاب:',
            style: AppTextStyling.font14W500TextInter.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed:
                    _passengerCount > 1
                        ? () {
                          setState(() {
                            _passengerCount--;
                          });
                        }
                        : null,
                icon: const Icon(Icons.remove),
              ),
              Text(
                _passengerCount.toString(),
                style: AppTextStyling.font14W500TextInter.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed:
                    _passengerCount < 20
                        ? () {
                          setState(() {
                            _passengerCount++;
                          });
                        }
                        : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Cargo Description
          Text(
            'وصف الحمولة (اختياري):',
            style: AppTextStyling.font14W500TextInter.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _cargoDescriptionController,
            maxLines: 2,
            maxLength: 200,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: 'وصف الحمولة...',
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 16),

          // Notes
          Text(
            'ملاحظات إضافية (اختياري):',
            style: AppTextStyling.font14W500TextInter.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _needVanNotesController,
            maxLines: 2,
            maxLength: 500,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: 'ملاحظات إضافية...',
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 20),

          // Submit Button
          BlocProvider(
            create:
                (context) => NeedVanBloc(
                  repository: NeedVanRepositoryImpl(
                    dataSource: NeedVanDataSource(),
                  ),
                ),
            child: BlocConsumer<NeedVanBloc, NeedVanState>(
              listener: (context, state) {
                if (state is NeedVanSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.response.message),
                      backgroundColor: AppColors.green,
                    ),
                  );
                  Navigator.of(context).pop(true);
                } else if (state is NeedVanError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('خطأ: ${state.message}'),
                      backgroundColor: AppColors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        state is NeedVanLoading ? null : _submitNeedVanRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        state is NeedVanLoading
                            ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('جاري الإرسال...'),
                              ],
                            )
                            : const Text('إرسال طلب السيارة الفان'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getNeedVanReasonDisplayName(NeedVanReason reason) {
    switch (reason) {
      case NeedVanReason.passengerCountExceeded:
        return 'عدد الركاب يتجاوز الحد المسموح';
      case NeedVanReason.cargoSizeExceeded:
        return 'حجم الحمولة يتجاوز الحد المسموح';
      case NeedVanReason.specialRequirements:
        return 'متطلبات خاصة';
    }
  }
}
