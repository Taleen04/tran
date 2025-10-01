import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MyBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const MyBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primaryText,
        unselectedItemColor: Colors.grey[400],
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label:AppLocalizations.of(context)!.myAccount,
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message_outlined),
            label:AppLocalizations.of(context)!.chat,
          ),
        ],
      ),
    );
  }
}
