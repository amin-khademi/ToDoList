import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task/data/data.dart';
import 'package:task/data/repo/repository.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  final TaskEntity _task;
  final Repository<TaskEntity> repository;
  EditTaskCubit(
    this._task,
    this.repository,
  ) : super(EditTaskInitial(_task));

  void OnSaveChangeClick() {
    repository.createOrUpdate(_task);
  }

  void OnTexChanged(String text) {
    _task.name = text;
  }

  void OnPriorityChanged(Priority priority) {
    _task.priority = priority;
    emit(EditTaskPriorityChanged(_task));
  }
}
