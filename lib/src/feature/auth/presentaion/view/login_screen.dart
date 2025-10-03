import 'package:ai_transport/main.dart';
import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/src/core/generated/l10n/app_localizations.dart';
import 'package:ai_transport/src/core/utils/responsive_size_helper.dart';
import 'package:ai_transport/src/feature/auth/presentaion/controllers/login_controllers.dart';
import 'package:ai_transport/src/feature/auth/presentaion/widgets/forget_password_button.dart';
import 'package:ai_transport/src/feature/auth/presentaion/widgets/header_text.dart';
import 'package:ai_transport/src/feature/auth/presentaion/widgets/login_button.dart';
import 'package:ai_transport/src/feature/auth/presentaion/widgets/password_field.dart';
import 'package:ai_transport/src/feature/auth/presentaion/widgets/phone_field.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/feature/auth/data/data_sources/auth_data_source.dart';
import 'package:ai_transport/src/feature/auth/presentaion/view_model/auth_bloc/bloc/auth_bloc.dart';
import 'package:ai_transport/src/feature/auth/repository/auth_repo.dart';

// -------------------- Wrapper --------------------
class LoginWrapper extends StatelessWidget {
  const LoginWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LogInBloc(AuthRepository(AuthDataSource())),
      child: const LoginScreen(),
    );
  }
}

// -------------------- Modern Login Screen --------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginControllers controllers;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controllers = LoginControllers();
    super.initState();
  }

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Form(
          key: _formKey,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const HeaderText(),
                  SizedBox(height: responsiveHeight(context, 90)),

                  // هنا بمرر الكونترولر اللي جهزته
                  PhoneField(controller: controllers.phoneController),
                  SizedBox(height: responsiveHeight(context, 20)),

                  PasswordField(
                    controller: controllers.passwordController,
                    text: AppLocalizations.of(context)!.enterYourPassword,
                  ),
                  SizedBox(height: responsiveHeight(context, 40)),

                  const ForgetPasswordButton(),
                  LoginButton(onPressed: handleLogin),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleLogin() async {
    HapticFeedback.mediumImpact();

    if (_formKey.currentState!.validate()) {
      final rawPhone = controllers.phoneController.text.trim();
      final userName = rawPhone.startsWith('0') ? rawPhone : '0$rawPhone';
      final password = controllers.passwordController.text.trim();
      final fcm = await FirebaseMessaging.instance.getToken() ?? "";

      context.read<LogInBloc>().add(
        LogInButtonPressed(userName, password, "123", fcm, context),
      );
      SharedPrefHelper.getString(StorageKeys.current_status);
      controllers.phoneController.clear();
      controllers.passwordController.clear();
    } else {
      // الحقول غير صحيحة، Form سيعرض رسائل الأخطاء تلقائيًا
    }
  }

  //   void handleLogin() {
  //     HapticFeedback.mediumImpact();

  //     final rawPhone = controllers.phoneController.text.trim();
  //     final userName = rawPhone.startsWith('0') ? rawPhone : '0$rawPhone';
  //     final password = controllers.passwordController.text.trim();

  //     if (userName.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: const Row(
  //             children: [
  //               Icon(Icons.warning_outlined, color: Colors.white),
  //               SizedBox(width: 10),
  //               Text('يرجى إدخال رقم الهاتف'),
  //             ],
  //           ),
  //           backgroundColor: Colors.orange,
  //         ),
  //       );
  //       return;
  //     }

  //     if (password.length < 6) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: const Row(
  //             children: [
  //               Icon(Icons.warning_outlined, color: Colors.white),
  //               SizedBox(width: 10),
  //               Text('كلمة المرور يجب أن تكون 6 أحرف على الأقل'),
  //             ],
  //           ),
  //           backgroundColor: Colors.orange,
  //         ),
  //       );
  //       return;
  //     }

  //     context.read<LogInBloc>().add(
  //       LogInButtonPressed(userName, password, "123"),
  //     );
  //     controllers.phoneController.clear();
  //     controllers.passwordController.clear();
  //   }
}
