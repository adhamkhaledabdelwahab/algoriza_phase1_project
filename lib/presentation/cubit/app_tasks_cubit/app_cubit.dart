import 'dart:math';

import 'package:algoriza_phase1_project/core/services/database_services.dart';
import 'package:algoriza_phase1_project/core/services/flutter_local_notification_services.dart';
import 'package:algoriza_phase1_project/data/models/favourite_model.dart';
import 'package:algoriza_phase1_project/data/models/task_colors.dart';
import 'package:algoriza_phase1_project/data/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'app_database_loaded_states.dart';
import 'app_database_loading_error_states.dart';
import 'app_database_loading_states.dart';
import 'app_notification_loaded_state.dart';
import 'app_notification_loading_error_state.dart';
import 'app_notification_loading_states.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  List<Task> tasks = [];
  List<Favourite> favourites = [];
  final DatabaseServices _databaseServices = DatabaseServices();
  final FlutterLocalNotificationService _notificationService =
      FlutterLocalNotificationService();

  static AppCubit get(BuildContext context) =>
      BlocProvider.of<AppCubit>(context);

  _changeState(AppState state) {
    Future.delayed(const Duration(milliseconds: 300)).then(
      (value) => emit(state),
    );
  }

  AppCubit() : super(AppInitialState()) {
    _databaseServices
        .initializeDatabase(_changeState, _insertDummyData)
        .then((value) {
      getAllTasks();
      getAllFavourites();
    });
    _initializeNotificationService();
  }

  Future<void> _initializeNotificationService() async {
    _changeState(AppNotificationLoadingState());
    try {
      bool? result = await _notificationService.initializeNotification();
      if (result == null || result == false) {
        _changeState(AppNotificationLoadingErrorState());
      } else {
        _changeState(AppNotificationLoadedState());
      }
    } catch (e) {
      _changeState(AppNotificationLoadingErrorState());
    }
  }

  Future<void> _insertDummyData(Database db) async {
    for (int i = 1; i <= 10; i++) {
      _changeState(AppDatabaseTaskInsertingState());
      String id = const Uuid().v4();
      try {
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
        int taskResult = await db.insert('tasks', task.toJson());
        _onDatabaseInsertTask(taskResult, task);
      } catch (e) {
        _changeState(AppDatabaseTaskInsertingErrorState());
      }
      if (i == 3 || i == 7 || i == 5) {
        try {
          int favResult =
              await db.insert('favourites', Favourite(taskId: id).toJson());
          _onDatabaseAddingTaskToFavourites(favResult, Favourite(taskId: id));
        } catch (e) {
          _changeState(AppDatabaseFavouritesTaskInsertingErrorState());
        }
      }
    }
  }

  Future<void> insertTask(Task task) async {
    _changeState(AppDatabaseTaskInsertingState());
    try {
      int id = await _databaseServices.insertTask(task);
      _onDatabaseInsertTask(id, task);
    } catch (e) {
      _onDatabaseInsertTaskError();
    }
  }

  void _onDatabaseInsertTask(int id, Task task) {
    if (id > 0) {
      tasks.add(task);
      _changeState(AppDatabaseTaskInsertedState());
    } else {
      _changeState(AppDatabaseTaskInsertingAlgorithmConflictErrorState());
    }
  }

  void _onDatabaseInsertTaskError() {
    _changeState(AppDatabaseTaskInsertingErrorState());
  }

  Future<void> deleteTask(Task task) async {
    _changeState(AppDatabaseTaskDeletingState());
    try {
      int count = await _databaseServices.deleteTask(task);
      _onDatabaseDeleteTask(count, task.id);
    } catch (e) {
      _onDatabaseDeleteTaskError();
    }
  }

  void _onDatabaseDeleteTask(int count, String id) {
    if (count > 0) {
      tasks.removeWhere((element) => element.id == id);
      _changeState(AppDatabaseTaskDeletedState());
    } else {
      _changeState(AppDatabaseTaskDeletingWrongIdErrorState());
    }
  }

  void _onDatabaseDeleteTaskError() {
    _changeState(AppDatabaseTaskDeletingErrorState());
  }

  Future<void> getAllTasks() async {
    _changeState(AppDatabaseTasksFetchingState());
    try {
      List<Map<String, dynamic>> data = await _databaseServices.getAllTasks();
      _onDatabaseFetchingTasks(data);
    } catch (e) {
      _onDatabaseFetchingTasksError();
    }
  }

  void _onDatabaseFetchingTasks(List<Map<String, dynamic>> value) {
    _getTaskFromJson(value);
    _changeState(AppDatabaseTasksFetchedState());
  }

  void _getTaskFromJson(List<Map<String, dynamic>> value) {
    tasks.clear();
    for (var element in value) {
      Task task = Task.fromJson(element);
      tasks.add(task);
    }
  }

  void _onDatabaseFetchingTasksError() {
    _changeState(AppDatabaseTasksFetchingErrorState());
  }

  Future<void> deleteAllTasks() async {
    _changeState(AppDatabaseTasksDeletingState());
    try {
      int count = await _databaseServices.deleteAllTasks();
      _onDatabaseDeletingTasks(count);
    } catch (e) {
      _onDatabaseDeletingTasksError();
    }
  }

  void _onDatabaseDeletingTasks(int count) {
    tasks.clear();
    _changeState(AppDatabaseTasksDeletedState());
  }

  void _onDatabaseDeletingTasksError() {
    _changeState(AppDatabaseTasksDeletingErrorState());
  }

  Future<void> markTaskAsCompleted(Task task) async {
    _changeState(AppDatabaseTaskUpdatingState());
    try {
      int count = await _databaseServices.markTaskAsCompleted(task.id);
      _onDatabaseUpdatingTask(count, task);
    } catch (e) {
      _onDatabaseUpdatingTaskError();
    }
  }

  void _onDatabaseUpdatingTask(int count, Task oldTask) {
    if (count > 0) {
      int index = tasks.indexWhere((element) => element.id == oldTask.id);
      Task updatedTask = Task(
        id: oldTask.id,
        title: oldTask.title,
        date: oldTask.date,
        startTime: oldTask.startTime,
        endTime: oldTask.endTime,
        color: oldTask.color,
        isCompleted: 1,
        notificationId: oldTask.notificationId,
      );
      tasks[index] = updatedTask;
      _changeState(AppDatabaseTaskUpdatedState());
    } else {
      _changeState(AppDatabaseTaskUpdatingWrongIdErrorState());
    }
  }

  void _onDatabaseUpdatingTaskError() {
    _changeState(AppDatabaseTaskUpdatingErrorState());
  }

  Future<void> getAllFavourites() async {
    _changeState(AppDatabaseFavouritesFetchingState());
    try {
      List<Map<String, dynamic>> data =
          await _databaseServices.getAllFavourites();
      _onDatabaseFetchingFavourites(data);
    } catch (e) {
      _onDatabaseFetchingFavouritesError();
    }
  }

  void _onDatabaseFetchingFavourites(List<Map<String, dynamic>> value) {
    _getFavouriteFromJson(value);
    _changeState(AppDatabaseFavouritesFetchedState());
  }

  void _getFavouriteFromJson(List<Map<String, dynamic>> value) {
    favourites.clear();
    for (var element in value) {
      Favourite favourite = Favourite.fromJson(element);
      favourites.add(favourite);
    }
  }

  void _onDatabaseFetchingFavouritesError() {
    _changeState(AppDatabaseFavouritesFetchingErrorState());
  }

  Future<void> addTaskToFavourite(Favourite favourite) async {
    _changeState(AppDatabaseFavouritesTaskInsertingState());
    try {
      int id = await _databaseServices.insertFavourite(favourite);
      _onDatabaseAddingTaskToFavourites(id, favourite);
    } catch (e) {
      _onDatabaseAddingTaskToFavouritesError();
    }
  }

  void _onDatabaseAddingTaskToFavourites(int id, Favourite favourite) {
    if (id > 0) {
      favourites.add(favourite);
      _changeState(AppDatabaseFavouritesTaskInsertedState());
    } else {
      _changeState(
          AppDatabaseFavouritesTaskInsertingAlgorithmConflictErrorState());
    }
  }

  void _onDatabaseAddingTaskToFavouritesError() {
    _changeState(AppDatabaseFavouritesTaskInsertingErrorState());
  }

  Future<void> deleteTaskFromFavourite(Favourite favourite) async {
    _changeState(AppDatabaseFavouritesTaskDeletingState());
    try {
      int count = await _databaseServices.deleteFavourite(favourite);
      _onDatabaseFavouritesTaskDeleting(count, favourite);
    } catch (e) {
      _onDatabaseFavouritesTaskDeletingError();
    }
  }

  void _onDatabaseFavouritesTaskDeleting(int count, Favourite favourite) {
    if (count > 0) {
      favourites.removeWhere((element) => element.taskId == favourite.taskId);
      _changeState(AppDatabaseFavouritesTaskDeletedState());
    } else {
      _changeState(AppDatabaseFavouritesTaskDeletingWrongIdErrorState());
    }
  }

  void _onDatabaseFavouritesTaskDeletingError() {
    _changeState(AppDatabaseFavouritesTaskDeletingErrorState());
  }

  Future<void> deleteAllFavourites() async {
    _changeState(AppDatabaseFavouritesDeletingState());
    try {
      int count = await _databaseServices.deleteAllTFavourites();
      _onDatabaseDeletingAllFavourites(count);
    } catch (e) {
      _onDatabaseDeletingAllFavouritesError();
    }
  }

  void _onDatabaseDeletingAllFavourites(int count) {
    favourites.clear();
    _changeState(AppDatabaseFavouritesDeletedState());
  }

  void _onDatabaseDeletingAllFavouritesError() {
    _changeState(AppDatabaseFavouritesDeletingErrorState());
  }

  Future<void> displayNotification(Task task) async {
    _changeState(AppNotificationDisplayingState());
    try {
      await _notificationService.displayNotification(task);
      _changeState(AppNotificationDisplayedState());
    } catch (e) {
      _changeState(AppNotificationDisplayingErrorState());
    }
  }

  Future<void> repeatNotification(Task task) async {
    _changeState(AppNotificationRepeatingState());
    try {
      await _notificationService.repeatNotification(task);
      _changeState(AppNotificationRepeatedState());
    } catch (e) {
      _changeState(AppNotificationRepeatingErrorState());
    }
  }

  Future<void> scheduleNotification(Task task) async {
    _changeState(AppNotificationSchedulingState());
    try {
      await _notificationService.scheduledNotification(task);
      _changeState(AppNotificationScheduledState());
    } catch (e) {
      _changeState(AppNotificationSchedulingErrorState());
    }
  }

  Future<void> cancelNotification(Task task) async {
    _changeState(AppNotificationCancelingState());
    try {
      await _notificationService.cancelNotification(task);
      _changeState(AppNotificationCanceledState());
    } catch (e) {
      _changeState(AppNotificationCancelingErrorState());
    }
  }

  Future<void> cancelAllNotifications() async {
    _changeState(AppNotificationAllNotificationCancelingState());
    try {
      await _notificationService.cancelAllNotifications();
      _changeState(AppNotificationAllNotificationCanceledState());
    } catch (e) {
      _changeState(AppNotificationAllNotificationCancelingErrorState());
    }
  }
}
