import 'package:equatable/equatable.dart';

class RequestTakeoverEntity extends Equatable {
  final String status;
  final String message;
  final RequestTakeoverDataEntity data;

  const RequestTakeoverEntity({
    required this.status,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [status, message, data];
}

class RequestTakeoverDataEntity extends Equatable {
  final int requestId;
  final int previousDriver;
  final int newDriver;
  final String reason;

  const RequestTakeoverDataEntity({
    required this.requestId,
    required this.previousDriver,
    required this.newDriver,
    required this.reason,
  });

  @override
  List<Object?> get props => [requestId, previousDriver, newDriver, reason];
}
