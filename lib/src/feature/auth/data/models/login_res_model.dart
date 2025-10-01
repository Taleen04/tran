import 'package:ai_transport/src/feature/auth/data/models/staff_model.dart';

class LoginResponse {
  final String status;
  final String message;
  final Staff staff;
  final String token;
  final String tokenType;

  LoginResponse({
    required this.status,
    required this.message,
    required this.staff,
    required this.token,
    required this.tokenType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      staff: Staff.fromJson(data['staff']),
      token: data['token'],
      tokenType: data['token_type'],
);
}
}