import 'package:equatable/equatable.dart';

abstract class RequestTakeoverEvent extends Equatable {
  const RequestTakeoverEvent();

  @override
  List<Object?> get props => [];
}

class TakeoverRequestEvent extends RequestTakeoverEvent {
  final int requestId;
  final String reason;
  final String previousDriverName;

  const TakeoverRequestEvent({
    required this.requestId,
    required this.reason,
    required this.previousDriverName,
  });

  @override
  List<Object?> get props => [requestId, reason, previousDriverName];
}
