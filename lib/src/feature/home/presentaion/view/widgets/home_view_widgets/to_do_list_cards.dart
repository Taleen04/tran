import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/feature/home/domain/entities/order_entity.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/to_do_list_cards_info.dart';
import 'package:flutter/material.dart';

class ToDoListCards extends StatelessWidget {
  final List<RequestEntity> tasks;
  const ToDoListCards({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            width: screenWidth * 0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0.1),
              color: AppColors.background.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ToDoListCardsInfo(order: task),
          ),
        );
      },
    );
  }
}
