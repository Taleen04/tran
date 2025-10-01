import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.loginTitle,
            style: AppTextStyling.font26W500TextInter.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 32, 
              color: AppColors.lightOrange
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            AppLocalizations.of(context)!.LoginToContinueYourJourney,
            style: AppTextStyling.font14W500TextInter.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
