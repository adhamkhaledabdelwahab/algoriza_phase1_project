import 'package:algoriza_phase1_project/data/models/models.dart';
import 'package:algoriza_phase1_project/presentation/components/components.dart';
import 'package:algoriza_phase1_project/presentation/pages/task_page/widgets/task_field_info_widget.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: MyAppBar(
          text: "Task Info",
          isBoardScreen: false,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              children: const [
                Text(
                  'Hello',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF121212),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'You have a new reminder',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF121212),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: task.color,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TaskFieldInfo(
                      iconData: Icons.text_format,
                      subtitle: task.title,
                      title: 'Title',
                    ),
                    TaskFieldInfo(
                      iconData: Icons.access_time,
                      subtitle: task.startTime,
                      title: 'Start Time',
                    ),
                    TaskFieldInfo(
                      iconData: Icons.access_time,
                      subtitle: task.endTime,
                      title: 'End Time',
                    ),
                    TaskFieldInfo(
                      iconData: Icons.calendar_today_outlined,
                      subtitle: task.date,
                      title: 'Date',
                    ),
                    TaskFieldInfo(
                      iconData: task.isCompleted == 0
                          ? Icons.downloading
                          : Icons.download_done,
                      subtitle:
                          task.isCompleted == 1 ? 'Completed' : 'Uncompleted',
                      title: 'Task State',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
