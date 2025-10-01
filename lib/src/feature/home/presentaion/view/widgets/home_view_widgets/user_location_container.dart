import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:flutter/material.dart';

Row userLocationContainer(String fromToText, String locationText) {
  return Row(
    children: [
      Text(
        fromToText,
        style: AppTextStyling.font14W500TextInter.copyWith(
          color: AppColors.textPrimary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        locationText,
        style: AppTextStyling.font14W500TextInter.copyWith(
          color: AppColors.textPrimary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
