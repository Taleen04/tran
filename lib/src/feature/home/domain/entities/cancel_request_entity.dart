import 'package:equatable/equatable.dart';

class CancelRequestEntity extends Equatable {
  final int requestId;
  final String status;
  final DateTime cancelledAt;
  final String reason;
  final int photosUploaded;

  const CancelRequestEntity({
    required this.requestId,
    required this.status,
    required this.cancelledAt,
    required this.reason,
    required this.photosUploaded,
  });

  @override
  List<Object?> get props => [requestId, status, cancelledAt, reason, photosUploaded];
}

class CancelRequestResponseEntity extends Equatable {
  final String status;
  final String message;
  final CancelRequestEntity data;

  const CancelRequestResponseEntity({
    required this.status,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [status, message, data];
}

enum CancellationReason {
  clientRefused('client_refused'),
  vehicleFailure('vehicle_failure'),
  unsuitableLuggage('unsuitable_luggage'),
  clientNotFound('client_not_found'),
  weatherConditions('weather_conditions'),
  other('other');

  const CancellationReason(this.value);
  final String value;

  static CancellationReason fromString(String value) {
    return CancellationReason.values.firstWhere(
      (reason) => reason.value == value,
      orElse: () => CancellationReason.other,
    );
  }
}
