import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_spacing.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/constants/font_weight_helper.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_data_profile_bloc/get_user_profile_bloc.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_data_profile_bloc/get_user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  bool isSwitched = false;
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
                    style: AppTextStyling.font26W500TextInter.copyWith(fontSize: 
                    20),
                  ),
                  SizedBox(height: responsiveWidth(context, 10)),
                  Text(state.userProfile.serviceType ?? '',
                    
                    style: AppTextStyling.font14W500TextInter,
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
                    )
            
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
