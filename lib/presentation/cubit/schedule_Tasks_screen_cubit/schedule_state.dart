part of 'schedule_cubit.dart';

@immutable
abstract class ScheduleState {}

class ScheduleInitialState extends ScheduleState {}

class ScheduleTasksLoadingState extends ScheduleState {}

class ScheduleTasksLoadingErrorState extends ScheduleState {}

class ScheduleTasksLoadedState extends ScheduleState {}

class ScheduleChangeSelectedDateState extends ScheduleState {}

class ScheduleChangingSelectedDateState extends ScheduleState {}

class ScheduleChangeSelectedDateErrorState extends ScheduleState {}

class ScheduleDatePickerDatesFetchingState extends ScheduleState {}

class ScheduleDatePickerDatesFetchingErrorState extends ScheduleState {}

class ScheduleDatePickerDatesFetchedState extends ScheduleState {}

class ScheduleSelectedDateTasksFetchingState extends ScheduleState {}

class ScheduleSelectedDateTasksFetchedState extends ScheduleState {}

class ScheduleSelectedDateTasksFetchingErrorState extends ScheduleState {}
