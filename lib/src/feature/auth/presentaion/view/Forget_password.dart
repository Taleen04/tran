import 'dart:developer';

import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:ai_transport/src/feature/auth/presentaion/widgets/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width * 0.9;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          // to be more responsive
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: fieldWidth,
            child: ElevatedButton(
              onPressed: () {
                log("إرسال رمز التحقق إلى: ${phoneController.text}");
                context.push("/otp_screen");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backGroundIcon,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
               AppLocalizations.of(context)!.SendVerificationCode,
                style: AppTextStyling.font14W500TextInter,
              ),
            ),
          ),
        ),
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back,color: AppColors.textPrimary,),
                onPressed: () {
                  context.pop(); 
                },
              ),
            ),
            SizedBox(height: responsiveHeight(context, 130)),
            Center(
              child: Text(
                AppLocalizations.of(context)!.EnterYourPhoneNumber,
                style: AppTextStyling.font26W500TextInter,
              ),
            ),
            SizedBox(height: responsiveHeight(context, 10)),
            Text(
            AppLocalizations.of(context)!.WeWillSendYouAVerificationCode,
              style: AppTextStyling.font14W500TextInter,
            ),
            SizedBox(height: responsiveHeight(context, 40)),
            CustomPhoneInput(controller: phoneController),
          ],
        ),
      ),
    );
  }
}
