import 'dart:developer';

import 'dart:developer';

import 'package:ai_transport/l10n/app_localizations.dart';
import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_spacing.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/constants/font_weight_helper.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:ai_transport/src/feature/profile/data/data_source/online_status_data_sourse.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/widgets/custom_list_tile.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_data_profile_bloc/get_user_profile_bloc.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_data_profile_bloc/get_user_profile_state.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/update_user_status/update_user_status_bloc.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/update_user_status/update_user_status_event.dart';
import 'package:ai_transport/src/feature/profile/repo/online_status_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  bool isSwitched = false;
  bool isOnline = false;
bool onlineStatus = false;

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
    return BlocConsumer<GetUserProfileBloc, GetUserProfileState>(
      listener: (context, state) {
        if (state is GetUserProfileFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        if (state is GetUserProfileLoading) {
          Center(child: CircularProgressIndicator());
        } else if (state is GetUserProfileSuccess) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              Column(
                children: [

                  Text(
                    state.userProfile.name,
                    style: AppTextStyling.font26W500TextInter.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: responsiveWidth(context, 10)),
                  Row(
                    children: [
                      Text(
                        isSwitched
                            ? AppLocalizations.of(context)!.on
                            : AppLocalizations.of(context)!.off,
                        style: AppTextStyling.font14W500TextInter.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: 8),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          toggleOnlineStatus(value);
                        },
                        activeColor: AppColors.primaryText,
                      ),
                      SizedBox(width: 8),
                      Text(
                        state.userProfile.serviceType ?? '',

                        style: AppTextStyling.font14W500TextInter,
                      ),
                    ],
                  ),
                  SizedBox(height: responsiveHeight(context, 10)),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: AppColors.orange,
                    size: 20,
                    weight: 16,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    state.userProfile.rating,
                    style: AppTextStyling.font14W500TextInter.copyWith(
                      color: AppColors.textWhite,
                      fontWeight: FontWeightHelper.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),

              // ),
            ],
          );
        } else if (state is GetUserProfileFailure) {
          return Center(child: Text("فشل تحميل  بيانات المستخدم"));
        }
        return const SizedBox.shrink();
      },
    );
  }


}
