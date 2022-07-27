import 'package:algoriza_phase1_project/presentation/components/components.dart';
import 'package:algoriza_phase1_project/presentation/cubit/schedule_Tasks_screen_cubit/schedule_cubit.dart';
import 'package:algoriza_phase1_project/presentation/pages/schedule_page/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduledTasksScreen extends StatelessWidget {
  const ScheduledTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleCubit(context),
      child: BlocListener<ScheduleCubit, ScheduleState>(
        listener: (context, state) {
          debugPrint('$state');
        },
        child: Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: MyAppBar(
              text: "Schedule",
              isBoardScreen: false,
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                const HorizontalDatePicker(),
                Divider(
                  color: Colors.grey[400],
                  thickness: 2,
                ),
                const SelectedDateWidget(),
                const SelectedDateTasks(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
