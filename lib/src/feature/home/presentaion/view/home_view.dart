import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/header.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/section_header.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Header(),
            SizedBox(height: responsiveFont(context, 20)),
            Expanded(child: SectionHeader()),
          ],
        ),
      ),
    );
  }
}
