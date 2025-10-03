import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/feature/profile/data/data_source/notification_data_source.dart';
import 'package:ai_transport/src/feature/profile/domain/repositories/notification_repository.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/cubit/notifications_cubit/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/responsive_size_helper.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // نقلنا القائمة إلى هنا لتصبح قابلة للتعديل

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => NotificationsCubit(
            NotificationRepository(NotificationDataSource()),
          )..fetchNotifications(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primaryText,
          elevation: 0,
          title: const Text(
            'الإشعارات',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<NotificationsCubit, NotificationsState>(
          listener: (context, state) {
            if (state is GetNotificationsFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            var cubit = context
                .read<NotificationsCubit>();
            if (state is GetNotificationsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.lightOrange),
              );
            }

            if (state is GetNotificationsFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.withOpacity(0.7),
                    ),
                    SizedBox(height: responsiveHeight(context, 20)),
                    Text(
                      'حدث خطأ في تحميل الاشعارات',
                      style: AppTextStyling.bodyLarge.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: responsiveHeight(context, 20)),
                    ElevatedButton(
                      onPressed:
                          () =>
                              cubit
                                  .fetchNotifications(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
                          if (cubit.notifications.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد اشعارات',
                    style: AppTextStyling.bodyLarge.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                );
              }



            return RefreshIndicator(
              onRefresh: () async {
                cubit.fetchNotifications();
                },
              child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cubit.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = cubit.notifications[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.textWhite,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primaryText.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications_active,
                              color: AppColors.primaryText,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  notification.title,
                                  textAlign: TextAlign.right,
                                  style: AppTextStyling.font14W500TextInter
                                      .copyWith(
                                        color: AppColors.primaryText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  notification.message,
                                  textAlign: TextAlign.right,
                                  style: AppTextStyling.font14W500TextInter
                                      .copyWith(
                                        color: AppColors.background.withOpacity(
                                          0.8,
                                        ),
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notification.createdAt.substring(0,10),
                                  textAlign: TextAlign.right,
                                  style: AppTextStyling.font14W500TextInter
                                      .copyWith(
                                        color: AppColors.background.withOpacity(
                                          0.6,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              cubit.readNotification(notification.id);
                            },
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: AppColors.background,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            );

          },
        ),
      ),
    );
  }
}
