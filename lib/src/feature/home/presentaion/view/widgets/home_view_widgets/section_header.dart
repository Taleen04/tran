import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/constants/app_text_styling.dart';
import 'package:ai_transport/src/core/constants/font_weight_helper.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:ai_transport/src/feature/auth/data/models/staff_model.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/order_list_cards.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/to_do_list_cards.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/orders_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/orders_event.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/tasks_bloc/tasks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SectionHeader extends StatelessWidget {
 
  const SectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            /// التبويبات
            TabBar(
              indicatorColor: AppColors.orange,
              labelStyle: AppTextStyling.heading3,
              onTap: (value) {
                if(value ==0){
                  context.read<TasksBloc>().add(
                    const GetMyRequests(status: 'accepted'),
                  );
                }else{
                  context.read<OrdersBloc>().add(
                    FetchOrders(vehicleType: "car", urgentOnly: true),
                  );
                }
              },

              tabs: [
                // تبويب المهام
                Tab(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.ToDoList,
                          style: AppTextStyling.font14W500TextInter.copyWith(
                            color: AppColors.textWhite,
                            fontWeight: FontWeightHelper.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        BlocBuilder<TasksBloc, TasksState>(
                          builder: (context, state) {
                            int count = 0;
                            if (state is TasksLoaded) {
                              count = state.tasksList.length;
                            }
                            return Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryText,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                count.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // تبويب الطلبات
                Tab(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.OrderList,
                          style: AppTextStyling.font14W500TextInter.copyWith(
                            color: AppColors.textWhite,
                            fontWeight: FontWeightHelper.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        BlocBuilder<OrdersBloc, OrdersState>(
                          builder: (context, state) {
                            int count = 0;
                            if (state is OrdersLoaded) {
                              count = state.orders.length;
                            }
                            return Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryText,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                count.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            /// محتوى التبويبات
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  /// تبويب المهام (ToDoList)
                  BlocBuilder<TasksBloc, TasksState>(
                    builder: (context, state) {
                      // تحديث قائمة المهام عند فتح التبويب
                      if (state is TasksInitial) {
                        context.read<TasksBloc>().add(
                          const GetMyRequests(status: 'accepted'),
                        );
                      }

                      if (state is TasksLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is TasksLoaded) {
                        return ToDoListCards(tasks: state.tasksList);
                      } else if (state is TasksError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox();
                    },
                  ),

                  /// تبويب الطلبات (OrderList)
                  BlocBuilder<OrdersBloc, OrdersState>(
                    builder: (context, state) {
                      // تحديث الطلبات عند فتح التبويب
                      if (state is OrdersInitial) {
                        context.read<OrdersBloc>().add(
                          FetchOrders(vehicleType: "car", urgentOnly: true),
                        );
                      }
                      return OrderListCards();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
