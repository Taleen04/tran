import 'package:ai_transport/src/bottom_nav_bar/nav_bar_bloc.dart';
import 'package:ai_transport/src/bottom_nav_bar/nav_bar_event.dart';
import 'package:ai_transport/src/bottom_nav_bar/nav_bar_state.dart';
import 'package:ai_transport/src/feature/chat/presentation/view/chat_list_screen.dart';
import 'package:ai_transport/src/feature/chat/presentation/providers/chat_provider.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/home_view.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/my_bottom_nav_bar.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if we need to switch to a specific tab from query parameters
    final routerState = GoRouterState.of(context);
    final tabParam = routerState.uri.queryParameters['tab'];
    if (tabParam != null) {
      final tabIndex = int.tryParse(tabParam);
      if (tabIndex != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            context.read<NavBloc>().add(NavChanged(tabIndex));
          } catch (e) {
            print('Error setting tab: $e');
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.selectedIndex,
            children: [
              const Profile(),
              const HomeView(),
              ChatProvider.provideChatBloc(child: const ChatListScreen()),
            ],
          ),

          bottomNavigationBar: MyBottomNavBar(
            selectedIndex: state.selectedIndex,
            onTap: (index) {
              context.read<NavBloc>().add(NavChanged(index));
            },
          ),
        );
      },
    );
  }
}
