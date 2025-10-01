import 'dart:developer';
import 'package:ai_transport/src/feature/home/repository/request_takeover_repo.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_takeover_bloc/request_takeover_event.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_takeover_bloc/request_takeover_state.dart';
import 'package:ai_transport/src/feature/home/utils/error_handler.dart';
import 'package:bloc/bloc.dart';

class RequestTakeoverBloc extends Bloc<RequestTakeoverEvent, RequestTakeoverState> {
  final RequestTakeoverRepository repository;

  RequestTakeoverBloc({required this.repository}) : super(RequestTakeoverInitial()) {
    on<TakeoverRequestEvent>(_onTakeoverRequest);
  }

  Future<void> _onTakeoverRequest(
    TakeoverRequestEvent event,
    Emitter<RequestTakeoverState> emit,
  ) async {
    emit(RequestTakeoverLoading());
    
    try {
      log('Taking over request ${event.requestId} from driver ${event.previousDriverName}...');
      
      final response = await repository.takeoverRequest(
        requestId: event.requestId,
        reason: event.reason,
      );
      
      emit(RequestTakeoverSuccess(takeoverResponse: response));
      log('Request ${event.requestId} taken over successfully');
    } catch (e) {
      log('Error taking over request: $e');
      emit(RequestTakeoverError(message: ErrorHandler.getTakeoverErrorMessage(e)));
    }
  }
}
