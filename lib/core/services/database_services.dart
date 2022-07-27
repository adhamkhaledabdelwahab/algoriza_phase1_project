import 'package:algoriza_phase1_project/data/models/favourite_model.dart';
import 'package:algoriza_phase1_project/data/models/task_model.dart';
import 'package:algoriza_phase1_project/presentation/cubit/app_tasks_cubit/app_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../../presentation/cubit/app_tasks_cubit/app_database_loaded_states.dart';
import '../../presentation/cubit/app_tasks_cubit/app_database_loading_error_states.dart';
import '../../presentation/cubit/app_tasks_cubit/app_database_loading_states.dart';

class DatabaseServices {
  Database? _database;
  final int _version = 1;
  final String _taskTableName = 'tasks';
  final String _favouriteTableName = 'favourites';
  final _taskTableCreateSqlStatement = 'CREATE TABLE tasks ('
      'notificationId INTEGER PRIMARY KEY AUTOINCREMENT,'
      'id STRING UNIQUE, '
      'title STRING, note TEXT, date STRING, '
      'startTime STRING, endTime STRING, '
      'reminder INTEGER, repeat INTEGER, '
      'color INTEGER, '
      'isCompleted INTEGER'
      ')';
  final _favouriteTableCreateSqlStatement = 'CREATE TABLE favourites ( '
      'taskId STRING, '
      'FOREIGN  KEY(taskId) REFERENCES tasks(id)'
      ')';
  late final Function(AppState state) _changeState;

  Future<void> initializeDatabase(Function(AppState state) changeState,
      Function(Database db) insertDummyData) async {
    _changeState = changeState;
    _changeState(AppDatabaseInitialState());
    if (_database != null) {
      _changeState(AppDatabaseOpenedState());
    } else {
      await _initializeDatabase(insertDummyData);
    }
  }

  Future<void> _initializeDatabase(
      Function(Database db) insertDummyData) async {
    String path = await _getAppDatabasePath();
    if (path.isNotEmpty) {
      return await _openAppDatabase(path, insertDummyData);
    }
  }

  Future<String> _getAppDatabasePath() async {
    _changeState(AppDatabasePathLoadingState());
    try {
      String path = '${await getDatabasesPath()}task.db';
      _changeState(AppDatabasePathLoadedState());
      return path;
    } catch (e) {
      _changeState(AppDatabasePathLoadingErrorState());
      return '';
    }
  }

  Future<void> _openAppDatabase(
      String path, Function(Database db) insertDummyData) async {
    _changeState(AppDatabaseLoadingState());
    try {
      _database = await openDatabase(
        path,
        version: _version,
        onCreate: (db, v) => _createAppDatabase(db, v, insertDummyData),
      );
      _changeState(AppDatabaseOpenedState());
    } catch (e) {
      _changeState(AppDatabaseLoadingErrorState());
    }
  }

  Future<void> _createAppDatabase(
      Database db, int v, Function(Database db) insertDummyData) async {
    await _createDatabaseTaskTable(db);
    await _createDatabaseFavouriteTable(db);
    await insertDummyData(db);
  }

  Future<void> _createDatabaseTaskTable(Database db) async {
    _changeState(AppDatabaseTaskTableCreatingState());
    try {
      await db.execute(_taskTableCreateSqlStatement);
      _changeState(AppDatabaseTaskTableCreatedState());
    } catch (e) {
      _changeState(AppDatabaseTaskTableCreatingErrorState());
    }
  }

  Future<void> _createDatabaseFavouriteTable(Database db) async {
    _changeState(AppDatabaseFavouriteTableCreatingState());
    try {
      await db.execute(_favouriteTableCreateSqlStatement);
      _changeState(AppDatabaseFavouriteTableCreatedState());
    } catch (e) {
      _changeState(AppDatabaseFavouriteTableCreatingErrorState());
    }
  }

  Future<List<Map<String, Object?>>> getAllTasks() async {
    return await _database!.query(_taskTableName);
  }

  Future<int> insertTask(Task task) async {
    return await _database!.insert(_taskTableName, task.toJson());
  }

  Future<int> markTaskAsCompleted(String id) async {
    return _database!.rawUpdate(
        'UPDATE tasks '
        'SET isCompleted = ? '
        'WHERE id = ?',
        [
          1,
          id,
        ]);
  }

  Future<int> deleteTask(Task task) async {
    return _database!
        .delete(_taskTableName, where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteAllTasks() async {
    return _database!.delete(_taskTableName);
  }

  Future<List<Map<String, Object?>>> getAllFavourites() async {
    return await _database!.query(_favouriteTableName);
  }

  Future<int> insertFavourite(Favourite favourite) async {
    try {
      return await _database!.insert(_favouriteTableName, favourite.toJson());
    } catch (e) {
      return 90000;
    }
  }

  Future<int> deleteFavourite(Favourite favourite) async {
    return _database!.delete(_favouriteTableName,
        where: 'taskId = ?', whereArgs: [favourite.taskId]);
  }

  Future<int> deleteAllTFavourites() async {
    return _database!.delete(_favouriteTableName);
  }
}
