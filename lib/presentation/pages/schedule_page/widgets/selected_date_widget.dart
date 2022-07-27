import 'package:algoriza_phase1_project/presentation/cubit/schedule_Tasks_screen_cubit/schedule_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SelectedDateWidget extends StatelessWidget {
  const SelectedDateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ScheduleCubit.get(context).fetchingSelectedDateWeekDay(
                    ScheduleCubit.get(context).selectedDate.weekday),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                DateFormat('dd MMMM, yyyy')
                    .format(ScheduleCubit.get(context).selectedDate),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey.shade600),
              ),
            ],
          ),
        );
      },
    );
  }
}
