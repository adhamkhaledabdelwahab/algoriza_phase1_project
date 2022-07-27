import 'package:algoriza_phase1_project/presentation/cubit/board_screen_cubit/board_cubit.dart';
import 'package:algoriza_phase1_project/presentation/components/empty_List_view.dart';
import 'package:algoriza_phase1_project/presentation/pages/board_page/widgets/task_list_item.dart';
import 'package:algoriza_phase1_project/presentation/components/tasks_view_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardCubit, BoardState>(
      builder: (context, state) {
        return state is BoardShowCompletedTasksState ||
                state is BoardShowAllTasksState ||
                state is BoardShowFavouriteTasksState ||
                state is BoardShowUncompletedTasksState
            ? ListView.builder(
                itemCount: BoardCubit.get(context).selectedTabTasks.length,
                itemBuilder: (_, index) {
                  return TaskListItem(
                    task: BoardCubit.get(context).selectedTabTasks[index],
                  );
                },
              )
            : state is BoardShowCompletedTasksErrorState ||
                    state is BoardShowAllTasksErrorState ||
                    state is BoardShowFavouriteTasksErrorState ||
                    state is BoardShowUncompletedTasksErrorState
                ? TasksViewErrorWidget(
                    taskKind: BoardCubit.get(context)
                        .tabsText[BoardCubit.get(context).selectedIndex],
                  )
                : const EmptyListView();
      },
    );
  }
}
