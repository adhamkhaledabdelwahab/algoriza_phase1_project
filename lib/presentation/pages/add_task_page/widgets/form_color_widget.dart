import 'package:algoriza_phase1_project/data/models/task_colors.dart';
import 'package:flutter/material.dart';

class AddTaskFormColorWidget extends StatelessWidget {
  const AddTaskFormColorWidget({
    Key? key,
    required this.onColorSelect,
    required this.selectedIndex,
  }) : super(key: key);

  final Function(int colorIndex) onColorSelect;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Color',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Wrap(
              children: List.generate(
                  taskColors.length,
                  (index) => GestureDetector(
                        onTap: () => onColorSelect(index),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundColor: taskColors[index],
                            radius: 14,
                            child: selectedIndex == index
                                ? const Icon(
                                    Icons.done,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                      )),
            )
          ],
        ),
      ],
    );
  }
}
