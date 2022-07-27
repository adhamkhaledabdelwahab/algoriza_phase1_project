import 'package:algoriza_phase1_project/data/models/task_model.dart';
import 'package:algoriza_phase1_project/presentation/pages/board_page/widgets/bottom_sheet_view.dart';
import 'package:algoriza_phase1_project/presentation/pages/task_page/task_screen.dart';
import 'package:flutter/material.dart';

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
      leading: Container(
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
    );
  }
}
