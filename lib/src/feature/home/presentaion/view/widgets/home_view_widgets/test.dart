import 'dart:developer';

import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/show_cancel_reasons.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/widgets/card_logout.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test Button")),
      body: Center(
        child: statusButton(
              " تعديل الطلب",
              AppTextStyling.font14W500TextInter.copyWith(color: AppColors.red),
              
              () {
                log("تم الضغط على الزر");
                showDialog(
                  context: context,
                  builder: (context) => const ShowCancelReasons(),
                );

              },
               AppColors.error, 
            ),
      ),
    );
  }
}
