import 'package:algoriza_phase1_project/data/models/models.dart';
import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_cubit.dart';
import 'package:algoriza_phase1_project/presentation/cubit/board_screen_cubit/board_cubit.dart';
import 'package:algoriza_phase1_project/presentation/pages/board_page/widgets/bottom_sheet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetView extends StatelessWidget {
  const BottomSheetView({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        BoardCubit boardCubit = BoardCubit.get(context);
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 4),
            width: double.infinity,
            height: task.isCompleted == 1 ? 280 : 360,
            color: Colors.grey[300],
            child: Column(
              children: [
                Flexible(
                  child: Container(
                    height: 6,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300]!,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                task.isCompleted == 1
                    ? Container()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BottomSheetItem(
                            label: 'Task Completed',
                            onTap: () => boardCubit
                                .markTaskAsCompleted(task, context)
                                .then((value) => Navigator.pop(context)),
                            clr: const Color(0xFF4e5ae8),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                BottomSheetItem(
                  label: appCubit.favourites
                          .any((element) => element.taskId == task.id)
                      ? 'Remove Task From Favourites'
                      : 'Add Task To Favourites',
                  onTap: () => boardCubit
                      .addOrRemoveTaskToOrFromFavourites(context, task)
                      .then((value) => Navigator.pop(context)),
                  clr: const Color(0xFF4e5ae8),
                ),
                const SizedBox(
                  height: 10,
                ),
                BottomSheetItem(
                  label: 'Delete Task',
                  onTap: () => boardCubit
                      .deleteTask(context, task)
                      .then((value) => Navigator.pop(context)),
                  clr: Colors.red[300]!,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: Color(0xFF121212),
                  thickness: 0.8,
                ),
                const SizedBox(
                  height: 5,
                ),
                BottomSheetItem(
                  label: 'Cancel',
                  onTap: () => Navigator.pop(context),
                  clr: const Color(0xFF4e5ae8),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
