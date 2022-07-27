import 'package:algoriza_phase1_project/presentation/components/empty_List_view.dart';
import 'package:algoriza_phase1_project/presentation/components/tasks_view_error_widget.dart';
import 'package:algoriza_phase1_project/presentation/cubit/schedule_Tasks_screen_cubit/schedule_cubit.dart';
import 'package:algoriza_phase1_project/presentation/pages/schedule_page/widgets/task_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        return state is ScheduleSelectedDateTasksFetchedState
            ? ListView.builder(
                itemCount: ScheduleCubit.get(context).selectedDateTasks.length,
                itemBuilder: (_, index) {
                  return TaskListItem(
                    task: ScheduleCubit.get(context).selectedDateTasks[index],
                  );
                },
              )
            : state is ScheduleSelectedDateTasksFetchingErrorState
                ? const TasksViewErrorWidget(
                    taskKind: 'Schedule',
                  )
                : const EmptyListView();
      },
    );
  }
}
