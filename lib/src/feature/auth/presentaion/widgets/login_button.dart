import 'package:ai_transport/main.dart';
import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:ai_transport/src/feature/auth/presentaion/view_model/auth_bloc/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/auth_bloc/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogInBloc, LogInState>(
      listener: (context, state) {
        if (state is LogInSuccess) {
          () async {
            try {
              HapticFeedback.heavyImpact();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 10),
                      Text('مرحباً ${state.user.name}'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              );

              final token = state.token;
              await SharedPrefHelper.setData(StorageKeys.token, token);
              log("تم تسجيل دخولك: ${state.user.name}");
               
              
              context.push("/car_info_view");
            } catch (e) {
              log('Error during login success handling', error: e);

            }
          }();
        } else if (state is LogFailure) {
          HapticFeedback.heavyImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(child: Text("فشل تسجيل الدخول")),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.lightOrange,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              
              alignment: Alignment.center,
              constraints: const BoxConstraints(minHeight: 50),
              child: Text(
                AppLocalizations.of(context)!.loginTitle,
                style: AppTextStyling.font14W500TextInter.copyWith(
                  color:AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
