part of 'task_list_bloc.dart';

@immutable
abstract class TaskListEvent {}

class TaskListStarted extends TaskListEvent {}

class TasklistSearch extends TaskListEvent {
  final String searchTerm;

  TasklistSearch(this.searchTerm);
}

class TasklistDeleteAll extends TaskListEvent {}
