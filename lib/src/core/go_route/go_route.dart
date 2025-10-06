import 'package:ai_transport/main.dart';
import 'package:ai_transport/src/bottom_nav_bar/nav_bar_bloc.dart';
import 'package:ai_transport/src/feature/auth/presentaion/view/Forget_password.dart';
import 'package:ai_transport/src/feature/auth/presentaion/view/otp_screen.dart';
import 'package:ai_transport/src/feature/auth/presentaion/view/update_password.dart';
import 'package:ai_transport/src/feature/auth/presentaion/view/login_screen.dart';
import 'package:ai_transport/src/feature/calender/presentation/view/calender.dart';
import 'package:ai_transport/src/feature/car_info/presentaion/view/car_info_view.dart';
import 'package:ai_transport/src/feature/chat/presentation/view/chat_list_screen.dart';
import 'package:ai_transport/src/feature/chat/presentation/view/chat_screen.dart';
import 'package:ai_transport/src/feature/chat/presentation/providers/chat_provider.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/home_view.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/main_screen.dart';
import 'package:ai_transport/src/feature/profile/data/data_source/edit_profile_data_source.dart';
import 'package:ai_transport/src/feature/profile/domain/entity/profile_entity.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/edit_user_info_view.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/notfication_screen.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/profile.dart';
import 'package:ai_transport/src/feature/profile/presentation/view/terms.dart';
import 'package:ai_transport/src/feature/profile/repo/edit_profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: checkIfUserSeenOnboarding(),
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => const LoginWrapper()),

      GoRoute(path: '/Profile', builder: (context, state) => const Profile()),

      //  GoRoute(
      //   path: '/forget_password',
      //   builder: (context, state) => const ForgetPasswordView(),
      // ),
      GoRoute(
        path: '/main_screen',
        builder:
            (context, state) => BlocProvider(
              create: (context) => NavBloc(),
              child: const MainScreen(),
            ),
      ),
      GoRoute(
        path: '/editProfile',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! StaffProfileEntity) {
            return const Scaffold(
              body: Center(child: Text('User data not provided')),
            );
          }
          return EditProfileView(
            user: extra,
            repository: EditProfileRepository(EditProfileDataSource()),
          );
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) {
          return NotificationsScreen();
        },
      ),

      GoRoute(
        path: '/car_info_view',
        builder: (context, state) => const CarInfoWrapper(),
      ),
      // GoRoute(
      //   path: '/vehicle_list',
      //   builder: (context, state) => const VehicleListWrapper(),
      // ),
      // GoRoute(
      //   path: '/vehicle_form',
      //   builder: (context, state) => const VehicleFormWrapper(),
      // ),
      GoRoute(
        path: '/change_password',
        builder: (context, state) => ChangePassword(),
      ),
      GoRoute(
        path: '/forget_password',
        builder: (context, state) => ForgetPasswordView(),
      ),
      GoRoute(
        path: '/home_view',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: '/otp_screen',
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(path: '/terms', builder: (context, state) => const TermsScreen()),
      GoRoute(
        path: '/chat_list',
        builder:
            (context, state) =>
                ChatProvider.provideChatBloc(child: const ChatListScreen()),
      ),
      GoRoute(
        path: '/chat/:requestId',
        builder: (context, state) {
          final requestId =
              int.tryParse(state.pathParameters['requestId'] ?? '0') ?? 0;
          final clientName = state.uri.queryParameters['clientName'] ?? 'عميل';

          return ChatProvider.provideChatBloc(
            child: ChatScreen(requestId: requestId, clientName: clientName),
          );
        },
      ),
      GoRoute(
        path: '/calender',
        builder: (context, state) => const CalendarScreen(),
      ),
    ],
  );
}
