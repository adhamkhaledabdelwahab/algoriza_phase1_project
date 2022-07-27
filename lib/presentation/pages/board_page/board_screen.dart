import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_cubit.dart';
import 'package:algoriza_phase1_project/presentation/cubit/board_screen_cubit/board_cubit.dart';
import 'package:algoriza_phase1_project/presentation/components/components.dart';
import 'package:algoriza_phase1_project/presentation/pages/add_task_page/add_task_screen.dart';
import 'package:algoriza_phase1_project/presentation/pages/board_page/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/app_tasks_cubit/app_database_loaded_states.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardCubit(context),
      child: BlocListener<AppCubit, AppState>(
        listener: (context, appState) {
          if (appState is AppDatabaseTasksFetchedState ||
              appState is AppDatabaseTasksDeletedState ||
              appState is AppDatabaseTaskInsertedState ||
              appState is AppDatabaseTaskDeletedState ||
              appState is AppDatabaseTaskUpdatedState ||
              appState is AppDatabaseFavouritesTaskDeletedState ||
              appState is AppDatabaseFavouritesTaskInsertedState ||
              appState is AppDatabaseFavouritesFetchedState ||
              appState is AppDatabaseFavouritesDeletedState) {
            BoardCubit.get(context).changeSelectedTab(
                BoardCubit.get(context).selectedIndex, context);
          }
        },
        child: BlocListener<BoardCubit, BoardState>(
          listener: (context, boardState) {
            debugPrint('$boardState');
          },
          child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: MyAppBar(
                text: 'Board',
                isBoardScreen: true,
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    const BoardTabBar(),
                    Container(
                      width: double.infinity,
                      height: 0.8,
                      color: Colors.grey,
                    ),
                    const BoardTabBarView(),
                    AppButton(
                      text: 'Add a task',
                      onPress: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddTaskScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
