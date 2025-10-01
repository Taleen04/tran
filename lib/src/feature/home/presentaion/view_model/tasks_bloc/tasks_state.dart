part of 'tasks_bloc.dart';

sealed class TasksState extends Equatable {
  const TasksState();
  
  @override
  List<Object> get props => [];
}

final class TasksInitial extends TasksState {}

final class TasksLoading extends TasksState {}

final class TasksLoaded extends TasksState {
  final List<RequestEntity> tasksList;
  const TasksLoaded(this.tasksList);

  @override
  List<Object> get props => [tasksList];
}

final class TasksError extends TasksState {
  final String message;

  const TasksError({required this.message});

}


