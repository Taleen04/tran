class NeedVanRequestModel {
  final String reason;
  final String? cargoDescription;
  final String? notes;
  final int passengerCount;

  NeedVanRequestModel({
    required this.reason,
    this.cargoDescription,
    this.notes,
    required this.passengerCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      if (cargoDescription != null) 'cargo_description': cargoDescription,
      if (notes != null) 'notes': notes,
      'passenger_count': passengerCount,
    };
  }

  factory NeedVanRequestModel.fromJson(Map<String, dynamic> json) {
    return NeedVanRequestModel(
      reason: json['reason'] as String,
      cargoDescription: json['cargo_description'] as String?,
      notes: json['notes'] as String?,
      passengerCount: json['passenger_count'] as int,
    );
  }
}

class NeedVanResponseModel {
  final String status;
  final String message;
  final NeedVanDataModel? data;

  NeedVanResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory NeedVanResponseModel.fromJson(Map<String, dynamic> json) {
    return NeedVanResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      data:
          json['data'] != null
              ? NeedVanDataModel.fromJson(json['data'] as Map<String, dynamic>)
              : null,
    );
  }
}

class NeedVanDataModel {
  final int requestId;
  final String status;
  final String updatedAt;

  NeedVanDataModel({
    required this.requestId,
    required this.status,
    required this.updatedAt,
  });

  factory NeedVanDataModel.fromJson(Map<String, dynamic> json) {
    return NeedVanDataModel(
      requestId: json['request_id'] as int,
      status: json['status'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

// Enum for need-van reasons
enum NeedVanReason {
  passengerCountExceeded('passenger_count_exceeded'),
  cargoSizeExceeded('cargo_size_exceeded'),
  specialRequirements('special_requirements');

  const NeedVanReason(this.value);
  final String value;

  static NeedVanReason fromString(String reason) {
    switch (reason.toLowerCase()) {
      case 'passenger_count_exceeded':
        return NeedVanReason.passengerCountExceeded;
      case 'cargo_size_exceeded':
        return NeedVanReason.cargoSizeExceeded;
      case 'special_requirements':
        return NeedVanReason.specialRequirements;
      default:
        throw ArgumentError('Unknown reason: $reason');
    }
  }
}
