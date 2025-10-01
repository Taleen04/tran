// import 'package:ai_transport/src/core/constants/app_colors.dart';
// import 'package:ai_transport/src/core/constants/app_text_styling.dart';
// import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_data_profile_bloc/get_user_profile_bloc.dart';
// import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_data_profile_bloc/get_user_profile_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CustomBottomSheet {
//   static Future<T?> show<T>(BuildContext context) {
//     return showModalBottomSheet<T>(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return BlocConsumer<GetUserProfileBloc, GetUserProfileState>(
//           listener: (context, state) {
//             if (state is GetUserProfileFailure) {
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text(state.error)));
//             }
//           },
//           builder: (context, state) {
//             if (state is GetUserProfileLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is GetUserProfileSuccess) {
//               return Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     ListTile(
//                       title: Text(
//                         "رقم الهاتف",
//                         style: AppTextStyling.font14W500TextInter.copyWith(
//                           color: AppColors.backGroundPrimary,
//                         ),
//                       ),
//                       leading: const Icon(Icons.phone, color: AppColors.orange),
//                       subtitle: Text(state.userProfile.phone), //! from api
//                     ),
//                     ListTile(
//                       title: Text(
//                         "رقم السيارة",
//                         style: AppTextStyling.font14W500TextInter.copyWith(
//                           color: AppColors.backGroundPrimary,
//                         ),
//                       ),
//                       leading: const Icon(
//                         Icons.numbers,
//                         color: AppColors.orange,
//                       ),
//                       subtitle: Text(""
//                         //state.userProfile. ??
//                             'vehicle number not found',
//                       ), //!from api
//                     ),
//                     ListTile(
//                       title: Text(
//                         "نوع السيارة",
//                         style: AppTextStyling.font14W500TextInter.copyWith(
//                           color: AppColors.backGroundPrimary,
//                         ),
//                       ),
//                       leading: const Icon(
//                         Icons.car_crash,
//                         color: AppColors.orange,
//                       ),
//                       subtitle: Text(""
//                         //state.userProfile.vehicle ?? '',
//                       ), //!from api
//                     ),
//                     ListTile(
//                       title: Text(
//                         "لون السيارة",
//                         style: AppTextStyling.font14W500TextInter.copyWith(
//                           color: AppColors.backGroundPrimary,
//                         ),
//                       ),
//                       leading: const Icon(
//                         Icons.color_lens,
//                         color: AppColors.orange,
//                       ),
//                       subtitle: Text(""), //!from api
//                     ),
//                   ],
//                 ),
//               );
//             } else if (state is GetUserProfileFailure) {
//               return Center(child: Text("فشل تحميل  بيانات المستخدم"));
//             }
//             return const SizedBox.shrink();
//           },
//         );
//       },
//     );
//   }
// }
