part of 'home_cubit.dart';

sealed class HomeState {}

class HomeInitial extends HomeState {}

//! Add Task
class AddTaskLoading extends HomeState {}

class AddTaskSuccess extends HomeState {
  final String message;

  AddTaskSuccess({required this.message});
}

class AddTaskError extends HomeState {
  final String error;

  AddTaskError({required this.error});
}

//! Get Task
class GetTaskLoading extends HomeState {}

class GetTaskSuccess extends HomeState {
  final List<AddTaskModel> listOfTask;

  GetTaskSuccess({required this.listOfTask});
}

class GetTaskError extends HomeState {
  final String error;

  GetTaskError({required this.error});
}

//! Update Task
class UpdateTaskLoading extends HomeState {}

class UpdateTaskSuccess extends HomeState {
  final String massege;

  UpdateTaskSuccess({required this.massege});
}

class UpdateTaskError extends HomeState {
  final String error;

  UpdateTaskError({required this.error});
}

//! Delete Task
class DeleteTaskLoading extends HomeState {}

class DeleteTaskSuccess extends HomeState {
  final String massege;

  DeleteTaskSuccess({required this.massege});
}

class DeleteTaskError extends HomeState {
  final String error;

  DeleteTaskError({required this.error});
}
