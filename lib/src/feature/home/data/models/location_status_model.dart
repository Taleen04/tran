import 'package:ai_transport/src/feature/home/domain/entities/location_status_entity.dart';

class LocationStatusModel extends LocationStatusEntity{
  @override
  final bool success;
  @override
  final String message;
  @override
  final String? locationStatus;

  LocationStatusModel({
    required this.success,
    required this.message,
    this.locationStatus,
  }) : super(success: success, message: message,locationStatus: locationStatus);

  factory LocationStatusModel.fromJson(Map<String, dynamic> json) {
    return LocationStatusModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      locationStatus: json['data']['location_status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'location_status': locationStatus,
      },
    };
  }

  LocationStatusEntity toEntity() {
    return LocationStatusEntity(
      success: success,
      message: message,
      locationStatus: locationStatus,
    );
  }
}
