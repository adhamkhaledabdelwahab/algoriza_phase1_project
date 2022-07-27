part of 'add_task_cubit.dart';

@immutable
abstract class AddTaskState {}

class AddTaskInitialState extends AddTaskState {}

class AddTaskSelectedDateChangedState extends AddTaskState {}

class AddTaskSelectedStartTimeChangedState extends AddTaskState {}

class AddTaskSelectedEndTimeChangedState extends AddTaskState {}

class AddTaskSelectedRemindChangedState extends AddTaskState {}

class AddTaskSelectedRepeatChangedState extends AddTaskState {}

class AddTaskSelectedColorChangedState extends AddTaskState {}

class AddTaskValidatingState extends AddTaskState {}

class AddTaskValidatedState extends AddTaskState {}

class AddTaskEmptyTaskTitleErrorState extends AddTaskState {}
