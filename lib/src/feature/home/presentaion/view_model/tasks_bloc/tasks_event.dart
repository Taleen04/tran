part of 'tasks_bloc.dart';

sealed class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class GetMyRequests extends TasksEvent {
  final String status;

  const GetMyRequests({required this.status});

  @override
  List<Object?> get props => [status];
}

class AddAcceptedTask extends TasksEvent {
  final RequestEntity task;

  const AddAcceptedTask(this.task);

  @override
  List<Object?> get props => [task];
}

class AcceptRequestEvent extends TasksEvent {
  final int requestId;
  const AcceptRequestEvent(this.requestId);

  @override
  List<Object?> get props => [requestId];
}
