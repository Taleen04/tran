import 'package:ai_transport/src/feature/auth/data/models/staff_model.dart';

class LoginResponseEntity {
  final String status;
  final String message;
  final Staff staff;
  final String token;
  final String tokenType;

  LoginResponseEntity({
    required this.status,
    required this.message,
    required this.staff,
    required this.token,
    required this.tokenType,
  });
}
