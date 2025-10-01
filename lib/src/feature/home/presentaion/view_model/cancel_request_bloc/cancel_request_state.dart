part of 'cancel_request_bloc.dart';

abstract class CancelRequestState extends Equatable {
  const CancelRequestState();

  @override
  List<Object?> get props => [];
}

class CancelRequestInitial extends CancelRequestState {
  const CancelRequestInitial();
}

class CancelRequestLoading extends CancelRequestState {
  const CancelRequestLoading();
}

class CancelRequestSuccess extends CancelRequestState {
  final CancelRequestResponseEntity response;

  const CancelRequestSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CancelRequestError extends CancelRequestState {
  final String message;

  const CancelRequestError(this.message);

  @override
  List<Object?> get props => [message];
}
