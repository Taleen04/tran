import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/constants/font_weight_helper.dart';
import 'package:ai_transport/src/core/utils/snack_bar_helper.dart';
import 'package:flutter/material.dart';

class TakeoverConfirmationDialog extends StatefulWidget {
  final String previousDriverName;
  final int requestId;
  final Function(String reason) onConfirm;

  const TakeoverConfirmationDialog({
    super.key,
    required this.previousDriverName,
    required this.requestId,
    required this.onConfirm,
  });

  @override
  State<TakeoverConfirmationDialog> createState() => _TakeoverConfirmationDialogState();
}

class _TakeoverConfirmationDialogState extends State<TakeoverConfirmationDialog> {
  final TextEditingController _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      title: Text(
        'تأكيد سحب الطلب',
        style: AppTextStyling.font14W500TextInter.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeightHelper.bold,
        ),
        textDirection: TextDirection.rtl,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'هل أنت متأكد أنك تريد سحب الطلب من "${widget.previousDriverName}"؟',
              style: AppTextStyling.font14W500TextInter.copyWith(
                color: AppColors.textPrimary,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            Text(
              'سبب السحب:',
              style: AppTextStyling.font14W500TextInter.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeightHelper.bold,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _reasonController,
              decoration: InputDecoration(
                hintText: 'أدخل سبب سحب الطلب...',
                hintStyle: AppTextStyling.font14W500TextInter.copyWith(
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.textSecondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              style: AppTextStyling.font14W500TextInter.copyWith(
                color: AppColors.textPrimary,
              ),
              textDirection: TextDirection.rtl,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال سبب السحب';
                }
                if (value.trim().length < 10) {
                  return 'يجب أن يكون السبب 10 أحرف على الأقل';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'إلغاء',
            style: AppTextStyling.font14W500TextInter.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onConfirm(_reasonController.text.trim());
              Navigator.of(context).pop();
              SnackbarUtils.showSuccess(context, "تم سحب الطلب بنجاح");
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: AppColors.textWhite,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          child: Text(
            'تأكيد السحب',
            style: AppTextStyling.font14W500TextInter.copyWith(
              color: AppColors.textWhite,
              fontWeight: FontWeightHelper.bold,
            ),
          ),
        ),
      ],
    );
  }
}
