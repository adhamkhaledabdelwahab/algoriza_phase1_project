import 'package:algoriza_phase1_project/data/models/task_reminders.dart';
import 'package:algoriza_phase1_project/data/models/task_repeat.dart';
import 'package:flutter/material.dart';

class CustomDropdownWidget extends StatelessWidget {
  const CustomDropdownWidget({
    Key? key,
    required this.dataMap,
    required this.onDropdownChange,
    this.iconData = Icons.keyboard_arrow_down,
    this.iconColor = Colors.grey,
  }) : super(key: key);

  final Map<int, dynamic> dataMap;
  final Function(int? val) onDropdownChange;
  final IconData iconData;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<int>(
          items: dataMap.keys
              .map(
                (e) => DropdownMenuItem<int>(
                  value: e,
                  child: Text(
                    dataMap.values.first is Reminder
                        ? getReminder(e)
                        : dataMap.values.first is Repeat
                            ? getRepeat(e)
                            : dataMap.values.toList()[e],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onDropdownChange,
          icon: Icon(
            iconData,
            color: iconColor,
          ),
          dropdownColor: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10),
          iconSize: 32,
          elevation: 4,
          underline: Container(
            height: 0,
          ),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          width: 6,
        ),
      ],
    );
  }
}
