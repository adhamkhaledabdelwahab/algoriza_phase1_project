import 'package:algoriza_phase1_project/presentation/components/empty_List_view.dart';
import 'package:algoriza_phase1_project/presentation/cubit/schedule_Tasks_screen_cubit/schedule_cubit.dart';
import 'package:algoriza_phase1_project/presentation/pages/schedule_page/widgets/task_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedDateTasks extends StatelessWidget {
  const SelectedDateTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        return Expanded(
          child: ScheduleCubit.get(context).selectedDateTasks.isNotEmpty
              ? const TaskListView()
              : const EmptyListView(),
        );
      },
    );
  }
}
