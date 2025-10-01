import 'dart:developer';
import 'package:ai_transport/src/feature/home/repository/request_status_update_repo.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_update_bloc/request_status_update_event.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_update_bloc/request_status_update_state.dart';
import 'package:bloc/bloc.dart';

class RequestStatusUpdateBloc extends Bloc<RequestStatusUpdateEvent, RequestStatusUpdateState> {
  final RequestStatusUpdateRepository repository;

  RequestStatusUpdateBloc({required this.repository}) : super(RequestStatusUpdateInitial()) {
    on<UpdateRequestStatusEvent>(_onUpdateRequestStatus);
  }

  Future<void> _onUpdateRequestStatus(
    UpdateRequestStatusEvent event,
    Emitter<RequestStatusUpdateState> emit,
  ) async {
    emit(RequestStatusUpdateLoading());
    
    try {
      log('Updating request ${event.requestId} status to ${event.status.value}');
      
      final response = await repository.updateRequestStatus(
        requestId: event.requestId,
        status: event.status,
        currentLocation: event.currentLocation,
        notes: event.notes,
      );
      
      emit(RequestStatusUpdateSuccess(response: response));
      log('Request status updated successfully: ${response.message}');
    } catch (e) {
      log('Error updating request status: $e');
      emit(RequestStatusUpdateError(message: e.toString()));
    }
  }
}
