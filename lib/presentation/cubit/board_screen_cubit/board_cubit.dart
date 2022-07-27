import 'package:algoriza_phase1_project/data/models/models.dart';
import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final List<String> tabsText = [
    "All",
    "Completed",
    "Uncompleted",
    "Favourite"
  ];
  List<Task> selectedTabTasks = [];
  final int tabsCount = 4;
  int selectedIndex = 0;

  BoardCubit(BuildContext context) : super(BoardInitialState()) {
    _changeSelectedTabTasks(context);
  }

  static BoardCubit get(BuildContext context) =>
      BlocProvider.of<BoardCubit>(context);

  _changeState(BoardState state) {
    Future.delayed(const Duration(milliseconds: 100))
        .then((value) => emit(state));
  }

  changeSelectedTab(int index, BuildContext context) {
    selectedIndex = index;
    _changeState(BoardChangeTabState());
    _changeSelectedTabTasks(context);
  }

  _changeSelectedTabTasks(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        _showAllTasks(context);
        return;
      case 1:
        _showCompletedTasks(context);
        return;
      case 2:
        _showUncompletedTasks(context);
        return;
      case 3:
        _showFavouriteTasks(context);
        return;
    }
  }

  _showAllTasks(BuildContext context) {
    try {
      selectedTabTasks = AppCubit.get(context).tasks;
      _changeState(BoardShowAllTasksState());
    } catch (e) {
      _changeState(BoardShowAllTasksErrorState());
    }
  }

  _showCompletedTasks(BuildContext context) {
    try {
      selectedTabTasks = AppCubit.get(context)
          .tasks
          .where((element) => element.isCompleted == 1)
          .toList();
      _changeState(BoardShowCompletedTasksState());
    } catch (e) {
      _changeState(BoardShowCompletedTasksErrorState());
    }
  }

  _showUncompletedTasks(BuildContext context) {
    try {
      selectedTabTasks = AppCubit.get(context)
          .tasks
          .where((element) => element.isCompleted == 0)
          .toList();
      _changeState(BoardShowUncompletedTasksState());
    } catch (e) {
      _changeState(BoardShowUncompletedTasksErrorState());
    }
  }

  _showFavouriteTasks(BuildContext context) {
    try {
      List<Task> tasks = [];
      List<Favourite> favourites = AppCubit.get(context).favourites;
      for (Favourite fav in favourites) {
        tasks.add(AppCubit.get(context)
            .tasks
            .firstWhere((element) => element.id == fav.taskId));
      }
      selectedTabTasks = tasks;
      _changeState(BoardShowFavouriteTasksState());
    } catch (e) {
      _changeState(BoardShowFavouriteTasksErrorState());
    }
  }
}
