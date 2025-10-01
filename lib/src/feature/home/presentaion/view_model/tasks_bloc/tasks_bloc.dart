import 'dart:developer';

import 'package:ai_transport/src/feature/home/domain/entities/order_entity.dart';
import 'package:ai_transport/src/feature/home/repository/order_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final OrderRepo orderRepo;
  TasksBloc(this.orderRepo) : super(TasksInitial()) {
    on<GetMyRequests>((event, emit) async {
      emit(TasksLoading());
      try {
        final res = await orderRepo.getMyRequests(event.status);

        emit(TasksLoaded(res));
        log("tasks loaded in bloc");
      } catch (e) {
        emit(TasksError(message: e.toString()));
        log("messageFromBloc$e");
      }
    });

    on<AddAcceptedTask>((event, emit) {
      final current =
          state is TasksLoaded
              ? (state as TasksLoaded).tasksList
              : <RequestEntity>[];
      final updated = List<RequestEntity>.from(current);
      final exists = updated.any((e) => e.id == event.task.id);
      if (!exists) {
        updated.insert(0, event.task);
      }
      emit(TasksLoaded(updated));
      log("[TasksBloc] Added accepted task id=${event.task.id}");
    });

    on<AcceptRequestEvent>((event, emit) async {
      try {
        final ok = await orderRepo.acceptRequest(event.requestId);
        if (ok) {
          final res = await orderRepo.getMyRequests('accepted');
          emit(TasksLoaded(res));
          log(' ${event.requestId} accepted and tasks refreshed');
        } else {
          emit(TasksError(message: 'Failed to accept request'));
        }
      } catch (e) {
        emit(TasksError(message: e.toString()));
      }
    });
  }
}
