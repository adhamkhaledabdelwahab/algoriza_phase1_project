import 'package:algoriza_phase1_project/presentation/pages/add_task_page/widgets/form_input_field_widget.dart';
import 'package:algoriza_phase1_project/presentation/pages/add_task_page/widgets/icon_button_widget.dart';
import 'package:flutter/material.dart';

class AddTaskFormTimeField extends StatelessWidget {
  const AddTaskFormTimeField({
    Key? key,
    required this.onStartTimePress,
    required this.onEndTimePress,
    required this.startTimeHint,
    required this.endTimeHint,
  }) : super(key: key);

  final Function() onStartTimePress;
  final Function() onEndTimePress;
  final String startTimeHint;
  final String endTimeHint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: AddTaskFormInputField(
            hint: startTimeHint,
            title: 'Start Time',
            widget: InputFieldSuffixWidget(
              icon: Icons.access_time_rounded,
              onPress: onStartTimePress,
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          flex: 1,
          child: AddTaskFormInputField(
            hint: endTimeHint,
            title: 'End time',
            widget: InputFieldSuffixWidget(
              icon: Icons.access_time_rounded,
              onPress: onEndTimePress,
            ),
          ),
        ),
      ],
    );
  }
}
