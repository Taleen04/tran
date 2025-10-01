import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_spacing.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:flutter/material.dart';

class RowItemCardDocument extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const RowItemCardDocument({
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Text(
            value,
            style: AppTextStyling.font14W500TextInter.copyWith(
              color: AppColors.green,
              fontSize: 12,
            ),
          ),
        ),
        Spacer(),
        Text(
          label,
          style: AppTextStyling.font14W500TextInter.copyWith(
            color: AppColors.textWhite,
            fontSize: 13,
          ),
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(width: AppSpacing.md),
        Icon(icon, color: AppColors.textWhite, size: 20),
      ],
    );
  }
}
