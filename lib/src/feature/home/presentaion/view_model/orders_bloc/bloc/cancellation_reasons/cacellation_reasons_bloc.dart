import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/cancellation_reasons/cacellation_reasons_event.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/cancellation_reasons/cacellation_reasons_state.dart';
import 'package:ai_transport/src/feature/home/repository/cancellation_reasons_repo.dart';
import 'package:bloc/bloc.dart';

class CancellationReasonsBloc extends Bloc<CanellationReasonsEvent, CancellationReasonsState> {
  final CancellationReasonsRepo repo;

  CancellationReasonsBloc({required this.repo}) : super(CancellationReasonsInitial()) {
    on<LoadCancellationReasons>(_onLoadCancellationReasons);
  }

  Future<void> _onLoadCancellationReasons(
      LoadCancellationReasons event,
      Emitter<CancellationReasonsState> emit) async {
    emit(CancellationReasonsLoading());
    try {
      final reasons = await repo.getCancellationReasons();
      emit(CancellationReasonsLoaded(reasons));
    } catch (e) {
      emit(CancellationReasonsError(e.toString()));
    }
  }
}
