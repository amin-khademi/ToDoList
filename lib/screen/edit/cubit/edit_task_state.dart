part of 'edit_task_cubit.dart';

@immutable
abstract class EditTaskState {
  final TaskEntity task;

  const EditTaskState(this.task);
}

class EditTaskInitial extends EditTaskState {
  const EditTaskInitial(super.task);
}

class EditTaskPriorityChanged extends EditTaskState {
  const EditTaskPriorityChanged(super.task);
}
