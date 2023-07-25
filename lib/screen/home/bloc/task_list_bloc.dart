import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task/data/data.dart';
import 'package:task/data/repo/repository.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<TaskEntity> repository;
  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TaskListStarted || event is TasklistSearch) {
        final String searchTerm;
        emit(TaskListLoading());
        await Future.delayed(const Duration(seconds: 1));
        if (event is TasklistSearch) {
          searchTerm = event.searchTerm;
        } else {
          searchTerm = '';
        }
        try {
          final items = await repository.getAll(searchKeyword: searchTerm);
          if (items.isNotEmpty) {
            emit(TaskListSuccess(items));
          } else {
            emit(TaskListEmpty());
          }
        } catch (e) {
          emit(TaskListError("خطای نامشخص "));
        }
      } else if (event is TasklistDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      }
    });
  }
}
