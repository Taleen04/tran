
import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:ai_transport/src/feature/auth/presentaion/widgets/resend_otp_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final int otpLength = 6;
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(otpLength, (_) => TextEditingController());
    focusNodes = List.generate(otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width * 0.9;
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: Padding(
        // to be more responsive
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: fieldWidth,
          child: ElevatedButton(
            onPressed: () {
            context.push("/change_password");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.backGroundIcon,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text("تحقق", style: AppTextStyling.font14W500TextInter),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Text(
              "ادخل رمز التحقق الخاص بك",
              style: AppTextStyling.font26W500TextInter,
            ),
            SizedBox(height: responsiveHeight(context, 20)),
            Center(
              child: Text(
                "ادخل الرمز المكون من 6 ارقام",
                style: AppTextStyling.font14W500TextInter,
              ),
            ),
            SizedBox(height: responsiveHeight(context, 130)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(otpLength, (index) {
                return Container(
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < otpLength - 1) {
                        focusNodes[index + 1].requestFocus();
                      }
                      if (value.isEmpty && index > 0) {
                        focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: responsiveHeight(context, 50)),
            ResendCountdown(),
          ],
        ),
      ),
    );
  }
}
