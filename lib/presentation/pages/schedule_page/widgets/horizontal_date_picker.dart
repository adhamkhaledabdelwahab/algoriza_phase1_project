import 'package:algoriza_phase1_project/presentation/cubit/schedule_Tasks_screen_cubit/schedule_cubit.dart';
import 'package:algoriza_phase1_project/presentation/pages/schedule_page/widgets/date_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HorizontalDatePicker extends StatelessWidget {
  const HorizontalDatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        return Container(
          height: 100,
          margin: const EdgeInsets.only(top: 10, left: 6, bottom: 5),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ScheduleCubit.get(context).datePickerDates.length,
            itemBuilder: (_, index) {
              return DateListItem(
                isSelected: ScheduleCubit.get(context)
                        .datePickerDates
                        .indexOf(ScheduleCubit.get(context).selectedDate) ==
                    index,
                weekDay: ScheduleCubit.get(context).getDayAbbr(
                    ScheduleCubit.get(context).datePickerDates[index].weekday),
                day: ScheduleCubit.get(context).datePickerDates[index].day,
                month: ScheduleCubit.get(context).getMonthAbbr(
                    ScheduleCubit.get(context).datePickerDates[index].month),
                onTap: () => ScheduleCubit.get(context)
                    .changeSelectedDate(index, context),
              );
            },
          ),
        );
      },
    );
  }
}
