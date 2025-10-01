class LogoutResponseModel {
  final List<dynamic> data;
  final String message;
  final bool status;

  LogoutResponseModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) {
    return LogoutResponseModel(
      data: json['data'] ?? [],
      message: json['message'] ?? '',
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'message': message,
      'status': status,
    };
  }
}
