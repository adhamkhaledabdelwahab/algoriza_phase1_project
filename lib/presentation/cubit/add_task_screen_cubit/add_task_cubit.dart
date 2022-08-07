import 'package:algoriza_phase1_project/data/models/models.dart';
import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final TextEditingController textEditingController = TextEditingController();
  String selectedDate = DateFormat.yMd().format(DateTime.now());
  String selectedStartTime = DateFormat('HH:mm aa').format(DateTime.now());
  String selectedEndTime = DateFormat('HH:mm aa')
      .format(DateTime.now().add(const Duration(minutes: 15)));
  int selectedRemindIndex = 0;
  String selectedReminder = '';
  int selectedRepeatIndex = 0;
  String selectedRepeat = '';
  int selectedColorIndex = 0;

  static AddTaskCubit get(BuildContext context) =>
      BlocProvider.of<AddTaskCubit>(context);

  changeState(AddTaskState state) {
    Future.delayed(const Duration(milliseconds: 100))
        .then((value) => emit(state));
  }

  AddTaskCubit() : super(AddTaskInitialState()) {
    selectedReminder = getReminder(selectedRemindIndex);
    changeState(AddTaskSelectedRemindChangedState());
    selectedRepeat = getRepeat(selectedRepeatIndex);
    changeState(AddTaskSelectedRepeatChangedState());
  }

  getDateFromUser(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(DateTime.now().year + 20),
    );
    if (pickedDate != null) {
      selectedDate = DateFormat.yMd().format(pickedDate);
      changeState(AddTaskSelectedDateChangedState());
    } else {
      debugPrint('It\'s null or something is wrong');
    }
  }

  getTimeFromUser(BuildContext context, {required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(
                const Duration(minutes: 15),
              ),
            ),
    );
    if (pickedTime != null) {
      isStartTime
          ? selectedStartTime = DateFormat('HH:mm aa').format(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              pickedTime.hour,
              pickedTime.minute))
          : selectedEndTime = DateFormat('HH:mm aa').format(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              pickedTime.hour,
              pickedTime.minute));
      changeState(isStartTime
          ? AddTaskSelectedStartTimeChangedState()
          : AddTaskSelectedEndTimeChangedState());
    } else {
      debugPrint('Time canceled or something wrong');
    }
  }

  changeTaskColor({required int colorIndex}) {
    selectedColorIndex = colorIndex;
    changeState(AddTaskSelectedColorChangedState());
  }

  changeTaskRepeat({required int repeatIndex}) {
    selectedRepeatIndex = repeatIndex;
    selectedRepeat = getRepeat(selectedRepeatIndex);
    changeState(AddTaskSelectedRepeatChangedState());
  }

  changeTaskRemind({required int remindIndex}) {
    selectedRemindIndex = remindIndex;
    selectedReminder = getReminder(selectedRemindIndex);
    changeState(AddTaskSelectedRemindChangedState());
  }

  createTask(BuildContext context) async {
    changeState(AddTaskValidatingState());
    if (textEditingController.text.isNotEmpty) {
      changeState(AddTaskValidatedState());
      Task task = Task(
          id: const Uuid().v4(),
          title: textEditingController.text,
          date: selectedDate,
          startTime: selectedStartTime,
          endTime: selectedEndTime,
          repeat: taskRepeats[selectedRepeatIndex]!,
          reminder: taskReminders[selectedRemindIndex]!,
          color: taskColors[selectedColorIndex]!);
      AppCubit cubit = AppCubit.get(context);
      await cubit.insertTask(task);
      task = cubit.tasks.firstWhere((element) => element.id == task.id);
      if (task.repeat == Repeat.none) {
        await cubit.scheduleNotification(task);
      } else {
        await cubit.repeatNotification(task);
      }
    } else {
      changeState(AddTaskEmptyTaskTitleErrorState());
    }
  }
}
