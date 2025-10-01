import 'package:ai_transport/src/feature/home/data/models/need_van_request_model.dart';

abstract class NeedVanEvent {}

class RequestNeedVanEvent extends NeedVanEvent {
  final int requestId;
  final NeedVanRequestModel needVanRequest;

  RequestNeedVanEvent({required this.requestId, required this.needVanRequest});
}
