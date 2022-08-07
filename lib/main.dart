import 'package:algoriza_phase1_project/core/services/services.dart';
import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_cubit.dart';
import 'package:algoriza_phase1_project/presentation/pages/splash_page/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseServices databaseServices = DatabaseServices();
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  FlutterLocalNotificationService notificationService =
      FlutterLocalNotificationService(plugin);
  Workmanager workManager = Workmanager();
  WorkManagerService workManagerService = WorkManagerService(workManager);
  runApp(
    BlocProvider(
      create: (BuildContext context) =>
          AppCubit(databaseServices, notificationService, workManagerService),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listener: (context, state) {
        debugPrint("$state");
      },
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Algoriza Phase1 Project',
        home: SplashScreen(),
      ),
    );
  }
}
