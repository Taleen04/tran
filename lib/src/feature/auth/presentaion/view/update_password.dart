import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:ai_transport/src/feature/auth/presentaion/widgets/password_field.dart';
import 'package:ai_transport/src/feature/profile/data/data_source/change_password_data_source.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/cubit/change_password/change_password_dart_cubit.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/cubit/change_password/change_password_dart_state.dart';
import 'package:ai_transport/src/feature/profile/repo/change_password_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/snack_bar_helper.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width * 0.9;

    return BlocProvider(
      create: (context) => ChangePasswordCubit(
        repo: ChangePasswordRepo(
          changePasswordDataSource: ChangePasswordDataSource(
            
          ),
        ),
      ),
      child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            SnackbarUtils.showSuccess(context, state.message);
            Navigator.pop(context);  // ارجاع المستخدم بعد النجاح
          } else if (state is ChangePasswordFailure) {
         SnackbarUtils.showError(context, state.error);
          }
        },
        builder: (context, state) {
          final isLoading = state is ChangePasswordLoading;

          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.85,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "إعادة تعيين كلمة المرور",
                        style: AppTextStyling.font26W500TextInter,
                      ),
                      SizedBox(height: responsiveHeight(context, 40)),
                      Text(
                        "يجب أن تحتوي كلمة المرور على مجموعة من الأرقام والأحرف والرموز الخاصة",
                        style: AppTextStyling.font14W500TextInter.copyWith(
                          color: AppColors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: responsiveHeight(context, 50)),

                      PasswordField( controller: currentPasswordController, text: 'كلمة المرور الحالية'),
                      SizedBox(height: responsiveHeight(context, 20)),
                      PasswordField( controller: newPasswordController, text: 'كلمة المرور الجديدة'),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: fieldWidth,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            FocusScope.of(context).unfocus();
                            final current = currentPasswordController.text.trim();
                            final newPass = newPasswordController.text.trim();

                            if (current.isEmpty || newPass.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("الرجاء تعبئة جميع الحقول")),
                              );
                              return;
                            }

                            context.read<ChangePasswordCubit>().changePassword(
                                  currentPassword: current,
                                  newPassword: newPass,
                                );

                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backGroundIcon,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text("إعادة تعيين", style: AppTextStyling.font14W500TextInter),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
