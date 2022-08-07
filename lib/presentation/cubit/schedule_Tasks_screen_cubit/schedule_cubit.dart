import 'package:algoriza_phase1_project/data/models/models.dart';
import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  List<DateTime> datePickerDates = [];
  List<Task> selectedDateTasks = [];
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  final int _startDate = DateTime.now().year;
  final int _endDate = DateTime.now().year + 20;

  static ScheduleCubit get(BuildContext context) =>
      BlocProvider.of<ScheduleCubit>(context);

  _changeState(ScheduleState state) {
    Future.delayed(const Duration(milliseconds: 100))
        .then((value) => emit(state));
  }

  ScheduleCubit(BuildContext context) : super(ScheduleInitialState()) {
    _fetchingDatePickerDates();
    _fetchingSelectedDateTasks(context);
  }

  changeSelectedDate(int index, BuildContext context) {
    _changeState(ScheduleChangingSelectedDateState());
    try {
      selectedDate = datePickerDates[index];
      _changeState(ScheduleChangeSelectedDateState());
      _fetchingSelectedDateTasks(context);
    } catch (e) {
      _changeState(ScheduleChangeSelectedDateErrorState());
    }
  }

  _fetchingSelectedDateTasks(BuildContext context) {
    _changeState(ScheduleSelectedDateTasksFetchingState());
    selectedDateTasks.clear();
    try {
      List<Task> tasks = AppCubit.get(context).tasks;
      for (Task task in tasks) {
        if (DateFormat.yMd().parse(task.date).compareTo(selectedDate) == 0 ||
            (task.repeat == Repeat.repeatDaily) ||
            (task.repeat == Repeat.repeatWeekly &&
                selectedDate
                            .difference(DateFormat.yMd().parse(task.date))
                            .inDays %
                        7 ==
                    0) ||
            task.repeat == Repeat.repeatMonthly &&
                selectedDate.day == DateFormat.yMd().parse(task.date).day) {
          selectedDateTasks.add(task);
        }
      }
      _changeState(ScheduleSelectedDateTasksFetchedState());
    } catch (e) {
      _changeState(ScheduleSelectedDateTasksFetchingErrorState());
    }
  }

  _fetchingDatePickerDates() {
    _changeState(ScheduleDatePickerDatesFetchingState());
    try {
      for (int year = _startDate; year <= _endDate; year++) {
        for (int month = DateTime.now().month; month <= 12; month++) {
          DateTime dateTime1 = DateTime(year, month, 1);
          DateTime dateTime2 = DateTime(year, month + 1, 1);
          int inDays =
              month + 1 == 13 ? 31 : dateTime2.difference(dateTime1).inDays;
          for (int day = DateTime.now().day; day <= inDays; day++) {
            datePickerDates.add(DateTime(year, month, day));
          }
        }
      }
      _changeState(ScheduleDatePickerDatesFetchedState());
    } catch (e) {
      _changeState(ScheduleDatePickerDatesFetchingErrorState());
    }
  }

  String fetchingSelectedDateWeekDay(int weekDay) {
    switch (weekDay) {
      case DateTime.sunday:
        return 'Sunday';
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      default:
        return 'Saturday';
    }
  }

  String getMonthAbbr(int month) {
    switch (month) {
      case DateTime.february:
        return 'Feb';
      case DateTime.march:
        return 'Mar';
      case DateTime.april:
        return 'Apr';
      case DateTime.may:
        return 'May';
      case DateTime.june:
        return 'Jun';
      case DateTime.july:
        return 'Jul';
      case DateTime.august:
        return 'Aug';
      case DateTime.september:
        return 'Sept';
      case DateTime.october:
        return 'Oct';
      case DateTime.november:
        return 'Nov';
      case DateTime.december:
        return 'Dec';
      default:
        return 'Jan';
    }
  }

  String getDayAbbr(int day) {
    switch (day) {
      case DateTime.sunday:
        return 'Sun';
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      default:
        return 'Sat';
    }
  }
}
