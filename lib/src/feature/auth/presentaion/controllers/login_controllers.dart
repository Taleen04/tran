import 'package:flutter/material.dart';

class LoginControllers {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  void clearAll() {
    phoneController.clear();
    passwordController.clear();
  }

  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
  }

  
}
//final loginControllers = LoginControllers();