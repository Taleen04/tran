 import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

Widget statItem(Widget icon, String value) {
    return Row(
      children: [
       icon,
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }