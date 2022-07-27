import 'package:algoriza_phase1_project/presentation/cubit/board_screen_cubit/board_cubit.dart';
import 'package:algoriza_phase1_project/presentation/components/empty_List_view.dart';
import 'package:algoriza_phase1_project/presentation/pages/board_page/widgets/task_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardTabBarView extends StatelessWidget {
  const BoardTabBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardCubit, BoardState>(
      builder: (context, state) {
        return Expanded(
          child: BoardCubit.get(context).selectedTabTasks.isNotEmpty
              ? const TaskListView()
              : const EmptyListView(),
        );
      },
    );
  }
}
