import 'package:algoriza_phase1_project/presentation/components/app_bar_widget.dart';
import 'package:algoriza_phase1_project/presentation/components/app_button_widget.dart';
import 'package:algoriza_phase1_project/presentation/cubit/add_task_screen_cubit/add_task_cubit.dart';
import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_cubit.dart';
import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_database_loaded_states.dart';
import 'package:algoriza_phase1_project/presentation/pages/add_task_page/widgets/form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskCubit(),
      child: BlocListener<AddTaskCubit, AddTaskState>(
        listener: (context, state) {
          debugPrint('$state');
        },
        child: Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: MyAppBar(
              text: "Add Task",
              isBoardScreen: false,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  const AddTaskForm(),
                  BlocConsumer<AppCubit, AppState>(
                    listener: (context, state) {
                      if (state is AppDatabaseTaskInsertedState) {
                        Navigator.pop(context);
                      }
                    },
                    builder: (context, state) {
                      return AppButton(
                        text: "Create a task",
                        onPress: () async {
                          FocusManager.instance.primaryFocus!.unfocus();
                          AddTaskCubit.get(context).createTask(context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
