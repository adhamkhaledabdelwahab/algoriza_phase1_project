import 'package:algoriza_phase1_project/data/models/task_model.dart';
import 'package:algoriza_phase1_project/presentation/pages/task_page/task_screen.dart';
import 'package:flutter/material.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: task.color,
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskScreen(task: task),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            task.startTime,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        subtitle: Text(
          task.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: task.isCompleted == 1
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 22,
                )
              : null,
        ),
      ),
    );
  }
}
