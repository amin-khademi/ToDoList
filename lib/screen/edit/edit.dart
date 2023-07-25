import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task/data/data.dart';
import 'package:task/data/repo/repository.dart';
import 'package:task/main.dart';
import 'package:task/screen/edit/cubit/edit_task_cubit.dart';

class EditTaskScreen extends StatefulWidget {
  EditTaskScreen({
    super.key,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
        text: context.read<EditTaskCubit>().state.task.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        elevation: 0,
        title: const Text("Edit Task"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.read<EditTaskCubit>().OnSaveChangeClick();
            Navigator.of(context).pop();
          },
          label: Row(
            children: const [
              Text("Save"),
              SizedBox(
                width: 4,
              ),
              Icon(
                CupertinoIcons.check_mark_circled_solid,
                size: 18,
              )
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<EditTaskCubit, EditTaskState>(
              builder: (context, state) {
                final priority = state.task.priority;
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                          onTap: () {
                            context
                                .read<EditTaskCubit>()
                                .OnPriorityChanged(Priority.high);
                          },
                          label: "High",
                          color: primaryColor,
                          isSelected: priority == Priority.high,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                            onTap: () {
                              context
                                  .read<EditTaskCubit>()
                                  .OnPriorityChanged(Priority.normal);
                            },
                            label: "Normal",
                            color: const Color(0xffF09819),
                            isSelected: priority == Priority.normal)),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                            onTap: () {
                              context
                                  .read<EditTaskCubit>()
                                  .OnPriorityChanged(Priority.low);
                            },
                            label: "Low",
                            color: lowPriority,
                            isSelected: priority == Priority.low)),
                  ],
                );
              },
            ),
            TextField(
              controller: _controller,
              onChanged: (value) {
                context.read<EditTaskCubit>().OnTexChanged(value);
              },
              decoration: InputDecoration(
                  label: Text(
                "Add task for today...",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .apply(fontSizeFactor: 1.2),
              )),
            )
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  @override
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  const PriorityCheckBox(
      {super.key,
      required this.label,
      required this.color,
      required this.isSelected,
      required this.onTap});

  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border:
              Border.all(width: 2, color: secondaryTextColor.withOpacity(0.2)),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
              right: 4,
              bottom: 0,
              top: 0,
              child: Center(
                child: CheckBOxShape(
                  value: isSelected,
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CheckBOxShape extends StatelessWidget {
  final bool value;
  final Color color;

  const CheckBOxShape({super.key, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), color: color),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 12,
            )
          : null,
    );
  }
}
