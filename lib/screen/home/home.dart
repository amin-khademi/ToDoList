import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task/data/data.dart';
import 'package:task/data/repo/repository.dart';
import 'package:task/main.dart';
import 'package:task/screen/edit/cubit/edit_task_cubit.dart';
import 'package:task/screen/edit/edit.dart';
import 'package:task/screen/home/bloc/task_list_bloc.dart';
import 'package:task/widgets.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlocProvider<EditTaskCubit>(
                      create: (context) => EditTaskCubit(
                          TaskEntity(), context.read<Repository<TaskEntity>>()),
                      child: EditTaskScreen(),
                    )));
          },
          label: Row(
            children: const [
              Text("Add Task"),
              SizedBox(
                width: 4,
              ),
              Icon(CupertinoIcons.add_circled_solid)
            ],
          )),
      body: BlocProvider<TaskListBloc>(
        create: (context) =>
            TaskListBloc(context.read<Repository<TaskEntity>>()),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  themeData.colorScheme.primary,
                  themeData.colorScheme.primaryVariant
                ])),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "To Do List",
                            style: themeData.textTheme.headline6!
                                .apply(color: Colors.white),
                          ),
                          Icon(
                            CupertinoIcons.share,
                            color: themeData.colorScheme.onPrimary,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 38,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19),
                            color: themeData.colorScheme.onPrimary,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20)
                            ]),
                        child: TextField(
                          onChanged: (value) {
                            context
                                .read<TaskListBloc>()
                                .add(TasklistSearch(value));
                          },
                          controller: controller,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.search),
                              label: Text("Search Tasks...")),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(child: Consumer<Repository<TaskEntity>>(
                builder: (context, model, child) {
                  context.read<TaskListBloc>().add(TaskListStarted());
                  return BlocBuilder<TaskListBloc, TaskListState>(
                    builder: (context, state) {
                      if (state is TaskListSuccess) {
                        return TaskList(
                            items: state.items, themeData: themeData);
                      } else if (state is TaskListEmpty) {
                        return const EmptyState();
                      } else if (state is TaskListLoading ||
                          state is TaskListInitial) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is TaskListError) {
                        return Center(
                          child: Text(state.errorMessage),
                        );
                      } else {
                        throw Exception("state is not valid...");
                      }
                    },
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themeData,
  });

  final List<TaskEntity> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today",
                      style: themeData.textTheme.headline6!
                          .apply(fontSizeFactor: 0.8),
                    ),
                    Container(
                      width: 70,
                      height: 3,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                          color: themeData.colorScheme.primary,
                          borderRadius: BorderRadius.circular(1.5)),
                    )
                  ],
                ),
                MaterialButton(
                  color: const Color(0xffEAEFF5),
                  textColor: secondaryTextColor,
                  elevation: 0,
                  onPressed: () {
                    context.read<TaskListBloc>().add(TasklistDeleteAll());
                  },
                  child: Row(
                    children: const [
                      Text("Delete all"),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        CupertinoIcons.delete,
                        size: 20,
                      )
                    ],
                  ),
                )
              ],
            );
          } else {
            final TaskEntity task = items[index - 1];
            return TaskItem(task: task);
          }
        });
  }
}

class TaskItem extends StatefulWidget {
  static const double height = 74;
  static const double borderRadius = 8;

  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final prioritycolor;
    switch (widget.task.priority) {
      case Priority.low:
        prioritycolor = lowPriority;
        // TODO: Handle this case.
        break;
      case Priority.normal:
        prioritycolor = normalPriority;
        // TODO: Handle this case.
        break;
      case Priority.high:
        prioritycolor = highpriority;
        // TODO: Handle this case.
        break;
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider<EditTaskCubit>(
                create: (context) => EditTaskCubit(
                    widget.task, context.read<Repository<TaskEntity>>()),
                child: EditTaskScreen())));
      },
      onLongPress: () {
        widget.task.delete();
      },
      child: Container(
        height: TaskItem.height,
        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        margin: const EdgeInsets.only(top: TaskItem.borderRadius),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: themeData.colorScheme.surface,
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.04))
            ]),
        child: Row(
          children: [
            MyCheckBox(
              value: widget.task.isComplete,
              onTap: () {
                setState(() {
                  widget.task.isComplete = !widget.task.isComplete;
                });
              },
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                widget.task.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    decoration: widget.task.isComplete
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              width: 6,
              height: TaskItem.height,
              decoration: BoxDecoration(
                  color: prioritycolor,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(TaskItem.borderRadius),
                      topRight: Radius.circular(TaskItem.borderRadius))),
            )
          ],
        ),
      ),
    );
  }
}
