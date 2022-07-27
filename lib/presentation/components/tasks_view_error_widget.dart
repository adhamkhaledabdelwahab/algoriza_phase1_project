import 'package:flutter/material.dart';

class TasksViewErrorWidget extends StatelessWidget {
  const TasksViewErrorWidget({Key? key, required this.taskKind})
      : super(key: key);

  final String taskKind;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/todo_error.png',
          height: 200,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Error showing $taskKind tasks!!!',
          style: const TextStyle(
            fontSize: 25,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
