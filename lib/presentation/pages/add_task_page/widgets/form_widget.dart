import 'package:algoriza_phase1_project/data/models/models.dart';
import 'package:algoriza_phase1_project/presentation/cubit/add_task_screen_cubit/add_task_cubit.dart';
import 'package:algoriza_phase1_project/presentation/pages/add_task_page/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTaskForm extends StatelessWidget {
  const AddTaskForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTaskCubit, AddTaskState>(
      builder: (context, state) {
        return Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  AddTaskFormInputField(
                    title: "Title",
                    hint: "Task title",
                    errText: state is AddTaskEmptyTaskTitleErrorState
                        ? '* Title field is required'
                        : null,
                    controller: AddTaskCubit.get(context).textEditingController,
                  ),
                  AddTaskFormInputField(
                    title: "Date",
                    hint: AddTaskCubit.get(context).selectedDate,
                    widget: InputFieldSuffixWidget(
                      icon: Icons.calendar_today_outlined,
                      onPress: () =>
                          AddTaskCubit.get(context).getDateFromUser(context),
                    ),
                  ),
                  AddTaskFormTimeField(
                    onEndTimePress: () =>
                        AddTaskCubit.get(context).getTimeFromUser(
                      context,
                      isStartTime: false,
                    ),
                    onStartTimePress: () =>
                        AddTaskCubit.get(context).getTimeFromUser(
                      context,
                      isStartTime: true,
                    ),
                    endTimeHint: AddTaskCubit.get(context).selectedEndTime,
                    startTimeHint: AddTaskCubit.get(context).selectedStartTime,
                  ),
                  AddTaskFormInputField(
                    title: 'Remind',
                    hint: AddTaskCubit.get(context).selectedReminder,
                    widget: CustomDropdownWidget(
                      dataMap: taskReminders,
                      onDropdownChange: (int? val) {
                        if (val != null) {
                          AddTaskCubit.get(context)
                              .changeTaskRemind(remindIndex: val);
                        }
                      },
                    ),
                  ),
                  AddTaskFormInputField(
                    title: 'Repeat',
                    hint: AddTaskCubit.get(context).selectedRepeat,
                    widget: CustomDropdownWidget(
                      dataMap: taskRepeats,
                      onDropdownChange: (int? val) {
                        if (val != null) {
                          AddTaskCubit.get(context)
                              .changeTaskRepeat(repeatIndex: val);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AddTaskFormColorWidget(
                    onColorSelect: (index) => AddTaskCubit.get(context)
                        .changeTaskColor(colorIndex: index),
                    selectedIndex: AddTaskCubit.get(context).selectedColorIndex,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
