import 'package:ai_transport/src/feature/auth/domain/entites/update_password_entity.dart';



class UpdatePasswordModel extends UpdatePasswordEntity {
  UpdatePasswordModel({
    required super.message,
    required super.status,
  });

  factory UpdatePasswordModel.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordModel(
      message: json['message'] ?? '',
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "status": status,
    };
  }
}
