import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/drivers_condition.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/user_info.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(20.0), child: UserInfo()),
          SizedBox(height: responsiveHeight(context, 20)),
          DriversCondition(),
        ],
      ),
    );
  }
}
