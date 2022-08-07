import 'package:algoriza_phase1_project/data/models/task_model.dart';
import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_cubit.dart';
import 'package:algoriza_phase1_project/presentation/pages/board_page/widgets/bottom_sheet_view.dart';
import 'package:algoriza_phase1_project/presentation/pages/task_page/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: IconButton(
        onPressed: () {
          showBottomSheet(
            context: context,
            builder: (context) => BottomSheetView(
              task: task,
            ),
          );
        },
        icon: const Icon(Icons.more_vert_outlined),
      ),
      title: Text(
        task.title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      contentPadding:
          const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TaskScreen(task: task),
        ),
      ),
      leading: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: task.color,
                  ),
                  color: task.isCompleted == 1 ? task.color : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: task.isCompleted == 1
                    ? const Icon(
                        Icons.check,
                        size: 18,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(
                width: 10,
              ),
              Icon(
                AppCubit.get(context)
                        .favourites
                        .any((element) => element.taskId == task.id)
                    ? Icons.favorite_outlined
                    : Icons.favorite_outline,
                color: task.color,
                size: 30,
              ),
            ],
          );
        },
      ),
    );
  }
}
