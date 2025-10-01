import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:ai_transport/src/feature/auth/presentaion/widgets/phone_input_field.dart';
import 'package:flutter/material.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          AppLocalizations.of(context)!.enterPhoneNumber,
          style: AppTextStyling.font14W500TextInter.copyWith(
            color: AppColors.textWhite,
          ),
        ),
        SizedBox(height: responsiveHeight(context, 10)),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: CustomPhoneInput(controller: controller),
        ),
      ],
    );
  }
}
