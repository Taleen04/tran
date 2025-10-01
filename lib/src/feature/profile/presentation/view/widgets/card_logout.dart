import 'dart:developer';
import 'package:ai_transport/main.dart';
import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/constants/font_weight_helper.dart';
import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:ai_transport/src/feature/auth/presentaion/view_model/auth_bloc/bloc/auth_bloc.dart';
import 'package:ai_transport/src/feature/auth/presentaion/view_model/auth_bloc/bloc/auth_state.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/location_status/location_status_bloc.dart';
import 'package:ai_transport/src/feature/profile/data/data_source/online_status_data_sourse.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/widgets/custom_list_tile.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/update_user_status/update_user_status_bloc.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/update_user_status/update_user_status_event.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/cubit/language_cubit.dart';
import 'package:ai_transport/src/feature/profile/repo/online_status_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsCard extends StatefulWidget {
  const SettingsCard({super.key, required this.token});

  final String token;

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  bool isOnline = false;
  bool onlineStatus = false;
  String currentStatus = 'offline';

  final repo = OnlineStatusRepo(dataSource: OnlineStatusDataSource());

  void toggleOnlineStatus(bool value) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // إرسال القيمتين للـ API
      final entity = await repo.updateOnlineStatus(
        value, // online_status
        value, // is_online
      );

      Navigator.of(context).pop();

      setState(() {
        isOnline = entity.isOnline;
        onlineStatus = entity.isOnline;
      });

      // ✅ إرسالها للـ Bloc
      context.read<UpdateUserStatusBloc>().add(
        UpdateUserStatusRequested(
          onlineStatus: entity.isOnline,
          isOnline: entity.isOnline,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            entity.isOnline ? 'تم تفعيل حالتك بنجاح' : 'تم إلغاء تفعيل حالتك',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      log('Failed to update status: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'فشل في تحديث حالتك',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'إعادة المحاولة',
            textColor: Colors.white,
            onPressed: () {
              toggleOnlineStatus(value);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backGroundIcon,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            AppLocalizations.of(context)!.Setting,
            style: AppTextStyling.font14W500TextInter.copyWith(
              color: AppColors.textWhite,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),

          // العناصر
          CustomListTile(
            icon: Icons.language,
            title: AppLocalizations.of(context)!.ChangeLanguage,
            isLanguageSwitch: true,
            switchValue:
                context.read<LanguageCubit>().state.locale.languageCode == 'en',
            onSwitchChanged: (value) {
              final cubit = context.read<LanguageCubit>();
              if (value) {
                cubit.changeLanguage(const Locale('en'));
              } else {
                cubit.changeLanguage(const Locale('ar'));
              }
            },
          ),

          CustomListTile(
            icon: Icons.change_circle,
            title: AppLocalizations.of(context)!.ChangeWorkStatus,
            isActive: true,
            switchValue: isOnline, // ✅ تكفي واحدة بس
            onStatusChanged: (value) {
              toggleOnlineStatus(value);
            },
          ),

          CustomListTile(
            icon: Icons.policy,
            title: AppLocalizations.of(context)!.ConditionsAndPrivacy,
            onTap: () {
              context.push('/terms');
            },
          ),
          CustomListTile(
            icon: Icons.password,
            title: AppLocalizations.of(context)!.ChangePassword,
            onTap: () {
              context.push("/change_password");
            },
          ),
          CustomListTile(
            icon: Icons.logout,
            title: AppLocalizations.of(context)!.Logout,

            isLogout: true,
            onTap: () {
              showModalBottomSheet(
                backgroundColor: AppColors.backGroundIcon,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!.Logout,
                            style: AppTextStyling.font14W500TextInter.copyWith(
                              color: AppColors.red,
                              fontWeight: FontWeightHelper.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.AreYouSureYouWantToLogOut,
                            style: AppTextStyling.font14W500TextInter.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(height: responsiveHeight(context, 30)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            statusButton(
                              AppLocalizations.of(context)!.cancel,
                              AppTextStyling.font14W500TextInter.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              () {
                                Navigator.pop(context);
                              },
                              AppColors.backGroundIcon,
                            ),
                            SizedBox(width: responsiveWidth(context, 10)),
                            BlocConsumer<LogoutBloc, LogoutState>(
                              listener: (context, state) async {
                                if (state is LogoutSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.message)),
                                  );
                                  // Clear SharedPref
                                  await SharedPrefHelper.removeData(
                                    StorageKeys.token,
                                  );
                                  await SharedPrefHelper.removeData(
                                    StorageKeys.locationStaff,
                                  );

                                  // ✅ صفري الـ LocationStatusBloc
                                  context.read<LocationStatusBloc>().add(
                                    LoadLocationEvent(),
                                  );

                                  // رجّعي المستخدم لصفحة الـ login
                                  context.go('/');

                                  // Debug logs
                                  final token =
                                      await SharedPrefHelper.getString(
                                        StorageKeys.token,
                                      );
                                  log('Token after logout: $token');

                                  final location =
                                      await SharedPrefHelper.getString(
                                        StorageKeys.locationStaff,
                                      );
                                  log("locationStaff after logout: $location");
                                } else if (state is LogoutFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.error)),
                                  );
                                } else if (state is LogoutFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.error)),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return statusButton(
                                  AppLocalizations.of(context)!.Logout,
                                  AppTextStyling.font14W500TextInter,
                                  () {
                                    context.read<LogoutBloc>().add(
                                      LogOutButtonPressed(widget.token),
                                    );
                                  },
                                  AppColors.red,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

ElevatedButton statusButton(
  String text,
  TextStyle style,
  final void Function()? onPressed,
  Color backgroundColor,
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      //foregroundColor:AppColors.error,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    ),
    onPressed: onPressed,
    child: Text(text, style: style),
  );
}
