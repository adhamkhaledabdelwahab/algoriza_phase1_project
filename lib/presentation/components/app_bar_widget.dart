import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_cubit.dart';
import 'package:algoriza_phase1_project/presentation/pages/schedule_page/scheduled_task_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_dropdown_widget.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    Key? key,
    required this.text,
    required this.isBoardScreen,
  }) : super(key: key);

  final String text;
  final bool isBoardScreen;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      toolbarHeight: 70,
      backgroundColor: Colors.white,
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
      leading: !isBoardScreen
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                CupertinoIcons.back,
                color: Colors.black,
              ),
            )
          : null,
      actions: isBoardScreen
          ? [
              CustomDropdownWidget(
                onDropdownChange: (int? val) {
                  if (val != null) {
                    switch (val) {
                      case 0:
                        AppCubit.get(context).deleteAllTasks();
                        AppCubit.get(context).deleteAllFavourites();
                        AppCubit.get(context).cancelAllNotifications();
                        break;
                      case 1:
                        AppCubit.get(context).deleteAllFavourites();
                        break;
                    }
                  }
                },
                dataMap: const {
                  0: 'Delete All Tasks',
                  1: 'Delete All Favourites',
                },
                iconData: Icons.more_vert_outlined,
                iconColor: Colors.black,
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ScheduledTasksScreen(),
                  ),
                ),
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black,
                ),
              ),
            ]
          : null,
    );
  }
}
