part of 'board_cubit.dart';

@immutable
abstract class BoardState {}

class BoardInitialState extends BoardState {}

class BoardChangeTabState extends BoardState {}

class BoardShowAllTasksState extends BoardState {}

class BoardShowAllTasksErrorState extends BoardState {}

class BoardShowCompletedTasksState extends BoardState {}

class BoardShowCompletedTasksErrorState extends BoardState {}

class BoardShowUncompletedTasksState extends BoardState {}

class BoardShowUncompletedTasksErrorState extends BoardState {}

class BoardShowFavouriteTasksState extends BoardState {}

class BoardShowFavouriteTasksErrorState extends BoardState {}
