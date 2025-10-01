import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_spacing.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/constants/font_weight_helper.dart';
import 'package:flutter/material.dart';

class DriverEvaluation extends StatelessWidget {
  const DriverEvaluation({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.orange,
                          size: 16,
                          weight: 16,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '4.9',
                          style: AppTextStyling.font14W500TextInter.copyWith(
                            color: AppColors.textWhite,
                            fontWeight: FontWeightHelper.bold,
                          ),
                        ),
                      ],
                    );
  }
}