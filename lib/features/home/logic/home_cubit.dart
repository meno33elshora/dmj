import 'package:bloc/bloc.dart';
import 'package:dmj_task/features/home/data/data_source/home_data_source.dart';
import 'package:dmj_task/features/home/data/model/add_task_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeDataSource _homeDataSource;
  HomeCubit(this._homeDataSource) : super(HomeInitial());

//! Add Task
  Future<void> addTaskCubit({required AddTaskModel addTaskModel}) async {
    try {
      emit(AddTaskLoading());
      await _homeDataSource.addTask(addTaskModel);

      emit(AddTaskSuccess(message: "Add Task Successfully"));
    } on Exception catch (ex) {
      emit(AddTaskError(error: ex.toString()));
    }
  }

  //! Get Task
  Stream<List<AddTaskModel>> getTaskCubit() {
    return _homeDataSource.getTasksStream();
  }

  //! Update Task
  Future<void> updateTaskCubit({
    required String taskId,
    required String title,
    required String describtion,
    required String status,
    required String statusValue,
  }) async {
    try {
      emit(UpdateTaskLoading());
      await _homeDataSource.updateTask(taskId, {
        "title": title,
        "describtion": describtion,
        "status": status,
        "statusValue": statusValue
      });
      emit(UpdateTaskSuccess(massege: "Add Task Successfully"));
    } on Exception catch (ex) {
      emit(UpdateTaskError(error: ex.toString()));
    }
  }

  //! Delete Task Cubit
  Future<void> deleteTaskCubit({
    required String taskId,
  }) async {
    try {
      emit(DeleteTaskLoading());
      await _homeDataSource.deleteTask(taskId);
      emit(DeleteTaskSuccess(massege: "Add Task Successfully"));
    } on Exception catch (ex) {
      emit(DeleteTaskError(error: ex.toString()));
    }
  }
}
