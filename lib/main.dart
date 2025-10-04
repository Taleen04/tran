import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:ai_transport/src/core/go_route/go_route.dart';
import 'package:ai_transport/src/feature/auth/data/data_sources/auth_data_source.dart';
import 'package:ai_transport/src/feature/auth/presentaion/view_model/auth_bloc/bloc/auth_bloc.dart';
import 'package:ai_transport/src/feature/auth/repository/auth_repo.dart';
import 'package:ai_transport/src/feature/home/data/data_sources/cancellation_reasons_data_source.dart';
import 'package:ai_transport/src/feature/home/data/data_sources/order_data_source.dart';
import 'package:ai_transport/src/feature/home/data/data_sources/request_status_update_data_source.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/cancellation_reasons/cacellation_reasons_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/orders_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/location_status/location_status_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_update_bloc/request_status_update_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_bloc/request_status_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_takeover_bloc/request_takeover_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/tasks_bloc/tasks_bloc.dart';
import 'package:ai_transport/src/feature/home/repository/cancellation_reasons_repo.dart';
import 'package:ai_transport/src/feature/home/repository/order_repo.dart';
import 'package:ai_transport/src/feature/home/repository/location_status_repo.dart';
import 'package:ai_transport/src/feature/home/data/data_sources/location_status_data_source.dart';
import 'package:ai_transport/src/feature/home/repository/request_status_update_repo.dart';
import 'package:ai_transport/src/feature/home/repository/request_status_repo.dart';
import 'package:ai_transport/src/feature/home/repository/request_takeover_repo.dart';
import 'package:ai_transport/src/feature/home/data/data_sources/request_status_data_source.dart';
import 'package:ai_transport/src/feature/home/data/data_sources/request_takeover_data_source.dart';
import 'package:ai_transport/src/feature/profile/data/data_source/profile_data_source.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_data_profile_bloc/get_user_profile_bloc.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/update_user_status/update_user_status_bloc.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/cubit/language_cubit.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/cubit/language_state.dart';
import 'package:ai_transport/src/feature/profile/repo/user_profile_repo.dart';
import 'package:ai_transport/src/feature/vehicle/data/data_sources/vehicle_check_data_source.dart';
import 'package:ai_transport/src/feature/vehicle/presentation/bloc/vehicle_check_bloc.dart';
import 'package:ai_transport/src/feature/vehicle/repository/vehicle_check_repository.dart';
import 'package:ai_transport/src/feature/calender/presentation/view_model/bloc/calender_bloc.dart';
import 'package:ai_transport/src/feature/calender/presentation/repo/calender_repo.dart';
import 'package:ai_transport/src/feature/calender/data/data_sourse/calender_data_sourse.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Main App
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LogoutBloc>(
          create: (context) => LogoutBloc(AuthRepository(AuthDataSource())),
        ),
        BlocProvider<UpdatePassword>(
          create: (context) => UpdatePassword(AuthRepository(AuthDataSource())),
        ),

        BlocProvider<RequestStatusUpdateBloc>(
          create:
              (context) => RequestStatusUpdateBloc(
                repository: RequestStatusUpdateRepositoryImpl(
                  dataSource: RequestStatusUpdateDataSource(),
                ),
              ),
        ),
        BlocProvider<RequestStatusBloc>(
          create:
              (context) => RequestStatusBloc(
                repository: RequestStatusRepositoryImpl(
                  dataSource: RequestStatusDataSource(),
                ),
              ),
        ),
        BlocProvider<RequestTakeoverBloc>(
          create:
              (context) => RequestTakeoverBloc(
                repository: RequestTakeoverRepositoryImpl(
                  dataSource: RequestTakeoverDataSource(),
                ),
              ),
        ),

        BlocProvider<GetUserProfileBloc>(
          create:
              (context) =>
                  GetUserProfileBloc(UserProfileRepo(UserProfileDataSource())),
        ),

        BlocProvider<UpdateUserStatusBloc>(
          create:
              (context) => UpdateUserStatusBloc(
                UserProfileRepo(UserProfileDataSource()),
              ),
        ),
        BlocProvider<TasksBloc>(
          create:
              (context) =>
                  TasksBloc(OrderRepo(dataSource: OrderDataSource()))
                    ..add(const GetMyRequests(status: 'accepted')),
        ),
        BlocProvider<OrdersBloc>(
          create:
              (context) =>
                  OrdersBloc(repo: OrderRepo(dataSource: OrderDataSource())),
        ),
        BlocProvider<LocationStatusBloc>(
          create:
              (context) => LocationStatusBloc(
                repo: LocationStatusRepo(
                  locationStatusDataSource: LocationStatusDataSource(),
                ),
                ordersBloc: context.read<OrdersBloc>(),
                tasksBloc: context.read<TasksBloc>(),
              ),
        ),

        BlocProvider<LanguageCubit>(
          create: (context) => LanguageCubit()..loadSavedLanguage(),
        ),
        BlocProvider<VehicleCheckBloc>(
          create:
              (context) => VehicleCheckBloc(
                repository: VehicleCheckRepository(VehicleCheckDataSource()),
              ),
        ),

        BlocProvider<CancellationReasonsBloc>(
          create:
              (context) => CancellationReasonsBloc(
                repo: CancellationReasonsRepo(
                  dataSource: CancellationReasonsDataSource(),
                ),
              ),
        ),
        BlocProvider<CalendarBloc>(
          create:
              (context) =>
                  CalendarBloc(CalendarRepository(CalendarDataSource())),
        ),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return MaterialApp.router(
            locale: state.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            title: 'Transport IA',
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}

class StorageKeys {
  const StorageKeys._();
  static const String token = 'token';
  static const String rememberMe = 'remember_me';
  static const String Language = 'Language';
  static const String notification = 'notification';
  static const String current_status = "current_status";
  static const String locationStaff = 'locationStaff';
  static const String vehicle_type = 'vehicle_type';
  static const String driver_id = "driver_id";
}

String checkIfUserSeenOnboarding() {
  final token = SharedPrefHelper.getString(StorageKeys.token);
  return (token.isNotEmpty && token != 'null') ? '/main_screen' : '/';
}
