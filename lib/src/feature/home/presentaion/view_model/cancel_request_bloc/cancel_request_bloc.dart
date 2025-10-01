import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ai_transport/src/feature/home/domain/entities/cancel_request_entity.dart';
import 'package:ai_transport/src/feature/home/domain/usecases/cancel_request_usecase.dart';

part 'cancel_request_event.dart';
part 'cancel_request_state.dart';

class CancelRequestBloc extends Bloc<CancelRequestEvent, CancelRequestState> {
  final CancelRequestUseCase _cancelRequestUseCase;

  CancelRequestBloc({
    required CancelRequestUseCase cancelRequestUseCase,
  }) : _cancelRequestUseCase = cancelRequestUseCase,
       super(CancelRequestInitial()) {
    on<CancelRequestSubmitted>(_onCancelRequestSubmitted);
    on<CancelRequestReset>(_onCancelRequestReset);
  }

  Future<void> _onCancelRequestSubmitted(
    CancelRequestSubmitted event,
    Emitter<CancelRequestState> emit,
  ) async {
    emit(CancelRequestLoading());
    
    try {
      final result = await _cancelRequestUseCase(
        CancelRequestParams(
          requestId: event.requestId,
          evidencePhotos: event.evidencePhotos,
          reason: event.reason,
          notes: event.notes,
        ),
      );
      
      emit(CancelRequestSuccess(result));
    } catch (e) {
      emit(CancelRequestError(e.toString()));
    }
  }

  void _onCancelRequestReset(
    CancelRequestReset event,
    Emitter<CancelRequestState> emit,
  ) {
    emit(CancelRequestInitial());
  }
}
