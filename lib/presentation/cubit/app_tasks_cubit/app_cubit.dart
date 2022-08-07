import 'dart:math';
import 'package:algoriza_phase1_project/core/errors/database_errors/database_errors.dart';
import 'package:algoriza_phase1_project/core/errors/notification_errors/notification_errors.dart';
import 'package:algoriza_phase1_project/core/errors/notification_work_manager_errors/notification_work_manager_errors.dart';
import 'package:algoriza_phase1_project/core/services/services.dart';
import 'package:algoriza_phase1_project/core/utils/helper_methods.dart';
import 'package:algoriza_phase1_project/data/models/models.dart';
import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_cubit_interfaces/app_cubit_interfaces.dart';
import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_states/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState>
    implements
        CubitDatabaseTaskInterface,
        CubitDatabaseFavouriteInterface,
        CubitNotificationInterface {
  List<Task> tasks = [];
  List<Favourite> favourites = [];
  final DatabaseServices _databaseServices;
  final FlutterLocalNotificationService _notificationService;
  final WorkManagerService _workManagerService;

  static AppCubit get(BuildContext context) =>
      BlocProvider.of<AppCubit>(context);

  _changeState(AppState state) {
    Future.delayed(const Duration(milliseconds: 200)).then(
      (value) => emit(state),
    );
  }

  AppCubit(this._databaseServices, this._notificationService,
      this._workManagerService)
      : super(AppInitialState()) {
    appInitialization();
  }

  Future<void> appInitialization() async {
    await _initializeAppNotificationService();
    await _initializeAppWorkManagerService();
    await _initializeAppDatabaseService();
  }

  Future<void> _initializeAppDatabaseService() async {
    try {
      _changeState(AppDatabaseInitializingState());
      await _databaseServices.initializeDatabaseService();
      _changeState(AppDatabaseInitializedState());
      if (_databaseServices.isOnCreate) {
        await _insertDummyData();
      }
      await fetchAllTasks();
      await fetchAllFavourites();
    } on DatabaseFetchingPathException catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabasePathLoadingErrorState());
    } on DatabaseFetchingPathEmptyValueException catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabasePathLoadingEmptyValueErrorState());
    } on DatabaseCreatingTaskTableException catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseTaskTableCreatingErrorState());
    } on DatabaseCreatingFavouriteTableException catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseFavouriteTableCreatingErrorState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseInitializingErrorState());
    }
  }

  Future<void> _initializeAppNotificationService() async {
    try {
      _changeState(AppNotificationInitializingState());
      await _notificationService.initializeNotificationService();
      _changeState(AppNotificationInitializedState());
    } on NotificationInitializingFalseOrNullValueException catch (e) {
      printErrMsg('$e');
      _changeState(AppNotificationInitializingFalseOrNullValueErrorState());
    } on NotificationIOSPermissionException catch (e) {
      printErrMsg('$e');
      _changeState(AppNotificationIOSPermissionError());
    } on NotificationIOSPermissionNotGrantedOrNullException catch (e) {
      printErrMsg('$e');
      _changeState(AppNotificationIOSPermissionNotGrantedOrNullErrorState());
    } on NotificationTimeZoneException catch (e) {
      printErrMsg('$e');
      _changeState(AppNotificationTimeZoneErrorState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppNotificationInitializingErrorState());
    }
  }

  Future<void> _initializeAppWorkManagerService() async {
    try {
      _changeState(AppWorkManagerInitializingState());
      await _workManagerService.initializeWorkManagerService();
      _changeState(AppWorkManagerInitializedState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppNotificationWorkManagerInitializationErrorState());
    }
  }

  Future<void> _insertDummyData() async {
    for (int i = 1; i <= 10; i++) {
      String id = const Uuid().v4();
      Task task = Task(
        id: id,
        title: 'Title $i',
        date: DateFormat.yMd().format(DateTime.now().add(Duration(days: i))),
        startTime: DateFormat('HH:mm aa').format(DateTime.now()),
        endTime: DateFormat('HH:mm aa').format(
          DateTime.now().add(
            const Duration(minutes: 30),
          ),
        ),
        color: taskColors[Random().nextInt(3)]!,
        isCompleted: Random().nextInt(1),
      );
      await insertTask(task);
      if (i == 3 || i == 7 || i == 5) {
        await insertTaskToFavourites(Favourite(taskId: id));
      }
    }
  }

  @override
  Future<void> deleteAllFavourites() async {
    _changeState(AppDatabaseAllFavouritesDeletingState());
    try {
      await _databaseServices.deleteAllFavourites();
      favourites.clear();
      _changeState(AppDatabaseFavouritesDeletedState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseFavouritesDeletingErrorState());
    }
  }

  @override
  Future<void> deleteAllTasks() async {
    _changeState(AppDatabaseAllTasksDeletingState());
    try {
      await _databaseServices.deleteAllTasks();
      tasks.clear();
      _changeState(AppDatabaseTasksDeletedState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseTasksDeletingErrorState());
    }
  }

  @override
  Future<void> deleteTask(Task task) async {
    _changeState(AppDatabaseTaskDeletingState());
    try {
      await _databaseServices.deleteTask(task);
      tasks.removeWhere((element) => element.id == task.id);
      _changeState(AppDatabaseTaskDeletedState());
    } on DatabaseDeletingTaskWrongIdException catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseTaskDeletingWrongIdErrorState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseTaskDeletingErrorState());
    }
  }

  @override
  Future<void> deleteTaskFromFavourites(Favourite favourite) async {
    _changeState(AppDatabaseFavouritesTaskDeletingState());
    try {
      await _databaseServices.deleteTaskFromFavourites(favourite);
      favourites.removeWhere((element) => element.taskId == favourite.taskId);
      _changeState(AppDatabaseFavouritesTaskDeletedState());
    } on DatabaseDeletingFavouriteWrongIdException catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseFavouritesTaskDeletingWrongIdErrorState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseFavouritesTaskDeletingErrorState());
    }
  }

  @override
  Future<void> fetchAllFavourites() async {
    _changeState(AppDatabaseAllFavouritesFetchingState());
    try {
      List<Map<String, dynamic>> data =
          await _databaseServices.fetchAllFavourites();
      _fetchFavouritesFromJson(data);
      _changeState(AppDatabaseFavouritesFetchedState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseFavouritesFetchingErrorState());
    }
  }

  void _fetchFavouritesFromJson(List<Map<String, dynamic>> data) {
    favourites.clear();
    for (var element in data) {
      Favourite favourite = Favourite.fromJson(element);
      favourites.add(favourite);
    }
  }

  @override
  Future<void> fetchAllTasks() async {
    _changeState(AppDatabaseAllTasksFetchingState());
    try {
      List<Map<String, dynamic>> data = await _databaseServices.fetchAllTasks();
      _fetchTasksFromJson(data);
      _changeState(AppDatabaseTasksFetchedState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseTasksFetchingErrorState());
    }
  }

  void _fetchTasksFromJson(List<Map<String, dynamic>> data) {
    tasks.clear();
    for (var element in data) {
      Task task = Task.fromJson(element);
      tasks.add(task);
    }
  }

  @override
  Future<void> insertTask(Task task) async {
    _changeState(AppDatabaseTaskInsertingState());
    try {
      await _databaseServices.insertTask(task);
      await _updateTasks(task, true);
      _changeState(AppDatabaseTaskInsertedState());
    } on DatabaseInsertingTaskAlgorithmConflictException catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseTaskInsertingAlgorithmConflictErrorState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseTaskInsertingErrorState());
    }
  }

  @override
  Future<void> insertTaskToFavourites(Favourite favourite) async {
    _changeState(AppDatabaseFavouritesTaskInsertingState());
    try {
      await _databaseServices.insertTaskToFavourites(favourite);
      favourites.add(favourite);
      _changeState(AppDatabaseFavouritesTaskInsertedState());
    } on DatabaseInsertingFavouriteAlgorithmConflictException catch (e) {
      printErrMsg('$e');
      _changeState(
          AppDatabaseFavouritesTaskInsertingAlgorithmConflictErrorState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseFavouritesTaskInsertingErrorState());
    }
  }

  @override
  Future<void> markTaskAsCompleted(Task task) async {
    _changeState(AppDatabaseTaskUpdatingState());
    try {
      await _databaseServices.markTaskAsCompleted(task);
      await _updateTasks(task, false);
      _changeState(AppDatabaseTaskUpdatedState());
    } on DatabaseUpdatingTaskWrongIdException catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseTaskUpdatingWrongIdErrorState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseTaskUpdatingErrorState());
    }
  }

  Future<void> _updateTasks(Task task, bool isInsert) async {
    Task? resultTask = await _fetchTask(task);
    if (resultTask != null) {
      if (isInsert == true) {
        tasks.add(resultTask);
      } else {
        tasks[tasks.indexWhere((element) => element.id == resultTask.id)] =
            resultTask;
      }
    } else {
      fetchAllTasks();
    }
  }

  Future<Task?> _fetchTask(Task task) async {
    try {
      List<Map<String, dynamic>> data = await _databaseServices.fetchTask(task);
      Task resultTask = Task.fromJson(data[0]);
      return resultTask;
    } on DatabaseFetchingTaskWrongIdException catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseFetchingTaskWrongIdErrorState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppDatabaseFetchingTaskErrorState());
    }
    return null;
  }

  @override
  Future<void> cancelAllNotifications() async {
    try {
      _changeState(AppNotificationAllNotificationCancelingState());
      await _notificationService.cancelAllNotifications();
      await _workManagerService.cancelAllTasks();
      _changeState(AppNotificationAllNotificationCanceledState());
    } on NotificationWorkManagerCancelAllTasksException catch (e) {
      printErrMsg('$e');
      _changeState(AppNotificationWorkManagerCancelingAllTasksErrorState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppNotificationAllNotificationCancelingErrorState());
    }
  }

  @override
  Future<void> cancelNotification(Task task) async {
    try {
      _changeState(AppNotificationCancelingState());
      await _notificationService.cancelNotification(task);
      await _workManagerService.cancelTaskByUniqueName(task);
      _changeState(AppNotificationCanceledState());
    } on NotificationWorkManagerCancelTaskByUniqueNameException catch (e) {
      printErrMsg('$e');
      _changeState(
          AppNotificationWorkManagerCancelingTaskByUniqueNameErrorState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppNotificationCancelingErrorState());
    }
  }

  @override
  Future<void> repeatNotification(Task task) async {
    try {
      _changeState(AppNotificationRepeatingState());
      await _workManagerService.registerPeriodicTask(task);
      _changeState(AppNotificationRepeatedState());
    } on NotificationWorkManagerRepeatTaskException catch (e) {
      printErrMsg('$e');
      _changeState(AppNotificationWorkManagerRepeatTaskErrorState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppNotificationRepeatingErrorState());
    }
  }

  @override
  Future<void> scheduleNotification(Task task) async {
    try {
      _changeState(AppNotificationSchedulingState());
      await _notificationService.scheduleNotification(task);
      _changeState(AppNotificationScheduledState());
    } catch (e) {
      printErrMsg('$e');
      _changeState(AppNotificationSchedulingErrorState());
    }
  }
}
