part of 'cancel_request_bloc.dart';

abstract class CancelRequestEvent extends Equatable {
  const CancelRequestEvent();

  @override
  List<Object?> get props => [];
}

class CancelRequestSubmitted extends CancelRequestEvent {
  final int requestId;
  final List<File> evidencePhotos;
  final CancellationReason reason;
  final String? notes;

  const CancelRequestSubmitted({
    required this.requestId,
    required this.evidencePhotos,
    required this.reason,
    this.notes,
  });

  @override
  List<Object?> get props => [requestId, evidencePhotos, reason, notes];
}

class CancelRequestReset extends CancelRequestEvent {
  const CancelRequestReset();
}
