import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_spacing.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:flutter/material.dart';

// ويدجت لكل صف معلومات
class ProfileRowItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileRowItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              label,
              style: AppTextStyling.font14W500TextInter.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: AppTextStyling.font14W500TextInter.copyWith(
                color: AppColors.textWhite,
              ),
            ),
          ],
        ),
        SizedBox(width: AppSpacing.md),
        Icon(icon, color: AppColors.primaryText, size: 20),
      ],
    );
  }
}
