import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_transport/src/feature/home/repository/need_van_repository.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/need_van_bloc/need_van_event.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/need_van_bloc/need_van_state.dart';

class NeedVanBloc extends Bloc<NeedVanEvent, NeedVanState> {
  final NeedVanRepository repository;

  NeedVanBloc({required this.repository}) : super(NeedVanInitial()) {
    on<RequestNeedVanEvent>(_onRequestNeedVan);
  }

  Future<void> _onRequestNeedVan(
    RequestNeedVanEvent event,
    Emitter<NeedVanState> emit,
  ) async {
    emit(NeedVanLoading());

    try {
      final response = await repository.requestNeedVan(
        requestId: event.requestId,
        needVanRequest: event.needVanRequest,
      );

      emit(NeedVanSuccess(response: response));
    } catch (e) {
      emit(NeedVanError(message: e.toString()));
    }
  }
}
