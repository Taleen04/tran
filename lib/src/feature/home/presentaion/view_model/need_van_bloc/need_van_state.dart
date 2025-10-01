import 'package:ai_transport/src/feature/home/data/models/need_van_request_model.dart';

abstract class NeedVanState {}

class NeedVanInitial extends NeedVanState {}

class NeedVanLoading extends NeedVanState {}

class NeedVanSuccess extends NeedVanState {
  final NeedVanResponseModel response;

  NeedVanSuccess({required this.response});
}

class NeedVanError extends NeedVanState {
  final String message;

  NeedVanError({required this.message});
}
