import 'dart:developer';
import 'package:ai_transport/src/feature/home/repository/request_status_repo.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_bloc/request_status_event.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_bloc/request_status_state.dart';
import 'package:ai_transport/src/feature/home/utils/error_handler.dart';
import 'package:bloc/bloc.dart';

class RequestStatusBloc extends Bloc<RequestStatusEvent, RequestStatusState> {
  final RequestStatusRepository repository;

  RequestStatusBloc({required this.repository}) : super(RequestStatusInitial()) {
    on<LoadRequestStatusesEvent>(_onLoadRequestStatuses);
    on<AcceptRequestEvent>(_onAcceptRequest);
    on<CancelAcceptanceEvent>(_onCancelAcceptance);
    on<RefreshRequestStatusEvent>(_onRefreshRequestStatus);
  }

  Future<void> _onLoadRequestStatuses(
    LoadRequestStatusesEvent event,
    Emitter<RequestStatusState> emit,
  ) async {
    emit(RequestStatusLoading());
    
    try {
      log('Loading request statuses...');
      final requestStatuses = await repository.getRequestStatuses();
      emit(RequestStatusLoaded(requestStatuses: requestStatuses));
      log('Request statuses loaded successfully: ${requestStatuses.length} items');
    } catch (e) {
      log('Error loading request statuses: $e');
      emit(RequestStatusError(message: e.toString()));
    }
  }

  Future<void> _onAcceptRequest(
    AcceptRequestEvent event,
    Emitter<RequestStatusState> emit,
  ) async {
    try {
      log('Accepting request ${event.requestId}...');
      final requestStatus = await repository.acceptRequest(event.requestId);
      emit(RequestAcceptedSuccess(requestStatus: requestStatus));
      log('Request ${event.requestId} accepted successfully');
    } catch (e) {
      log('Error accepting request: $e');
      
      emit(RequestStatusError(message: ErrorHandler.getAcceptRequestErrorMessage(e)));
    }
  }

  Future<void> _onCancelAcceptance(
    CancelAcceptanceEvent event,
    Emitter<RequestStatusState> emit,
  ) async {
    try {
      log('Cancelling acceptance for request ${event.requestId}...');
      final requestStatus = await repository.cancelAcceptance(event.requestId);
      emit(RequestAcceptanceCancelledSuccess(requestStatus: requestStatus));
      log('Acceptance cancelled for request ${event.requestId}');
    } catch (e) {
      log('Error cancelling acceptance: $e');
      
      emit(RequestStatusError(message: ErrorHandler.getErrorMessage(e)));
    }
  }

  Future<void> _onRefreshRequestStatus(
    RefreshRequestStatusEvent event,
    Emitter<RequestStatusState> emit,
  ) async {
    add(LoadRequestStatusesEvent());
  }
}
