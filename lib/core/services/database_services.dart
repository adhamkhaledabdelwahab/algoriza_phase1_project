import 'package:algoriza_phase1_project/core/errors/database_errors/database_errors.dart';
import 'package:algoriza_phase1_project/core/services/database_interfaces/database_interfaces.dart';
import 'package:algoriza_phase1_project/data/models/models.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseServices
    implements DatabaseTaskInterface, DatabaseFavouriteInterface {
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
  bool isOnCreate = false;

  Future<void> initializeDatabaseService() async {
    if (_database != null) {
      return;
    } else {
      return await _initializeDatabase();
    }
  }

  Future<void> _initializeDatabase() async {
    String path = await _getAppDatabasePath();
    if (path.isNotEmpty) {
      return await _openAppDatabase(path);
    }
    throw DatabaseFetchingPathEmptyValueException();
  }

  Future<String> _getAppDatabasePath() async {
    try {
      String path = '${await getDatabasesPath()}task.db';
      return path;
    } catch (e) {
      throw DatabaseFetchingPathException('$e');
    }
  }

  Future<void> _openAppDatabase(String path) async {
    try {
      _database = await openDatabase(
        path,
        version: _version,
        onCreate: (db, v) => _createAppDatabase(db, v),
      );
    } on DatabaseCreatingTaskTableException catch (e) {
      throw DatabaseCreatingTaskTableException('$e');
    } on DatabaseCreatingFavouriteTableException catch (e) {
      throw DatabaseCreatingFavouriteTableException('$e');
    } catch (e) {
      throw DatabaseLoadingException('$e');
    }
  }

  Future<void> _createAppDatabase(Database db, int v) async {
    isOnCreate = true;
    await _createTaskTable(db);
    await _createFavouriteTable(db);
  }

  Future<void> _createTaskTable(Database db) async {
    try {
      return await db.execute(_taskTableCreateSqlStatement);
    } catch (e) {
      throw DatabaseCreatingTaskTableException('$e');
    }
  }

  Future<void> _createFavouriteTable(Database db) async {
    try {
      await db.execute(_favouriteTableCreateSqlStatement);
    } catch (e) {
      throw DatabaseCreatingFavouriteTableException('$e');
    }
  }

  @override
  Future<int> deleteAllTasks() async {
    try {
      return await _database!.delete(_taskTableName);
    } catch (e) {
      throw DatabaseDeletingTasksException('$e');
    }
  }

  @override
  Future<int> deleteTask(Task task) async {
    try {
      int count = await _database!
          .delete(_taskTableName, where: 'id = ?', whereArgs: [task.id]);
      if (count > 0) {
        return count;
      }
      throw DatabaseDeletingTaskWrongIdException();
    } on DatabaseDeletingTaskWrongIdException {
      throw DatabaseDeletingTaskWrongIdException();
    } catch (e) {
      throw DatabaseDeletingTaskException('$e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAllTasks() async {
    try {
      return await _database!.query(_taskTableName);
    } catch (e) {
      throw DatabaseFetchingTasksException('$e');
    }
  }

  @override
  Future<int> insertTask(Task task) async {
    try {
      int id = await _database!.insert(_taskTableName, task.toJson());
      if (id != 0) {
        return id;
      }
      throw DatabaseInsertingTaskAlgorithmConflictException();
    } on DatabaseInsertingTaskAlgorithmConflictException {
      throw DatabaseInsertingTaskAlgorithmConflictException();
    } catch (e) {
      throw DatabaseInsertingTaskException('$e');
    }
  }

  @override
  Future<int> markTaskAsCompleted(Task task) async {
    try {
      int count = await _database!.rawUpdate(
          'UPDATE tasks '
          'SET isCompleted = ? '
          'WHERE id = ?',
          [
            1,
            task.id,
          ]);
      if (count > 0) {
        return count;
      }
      throw DatabaseUpdatingTaskWrongIdException();
    } on DatabaseUpdatingTaskWrongIdException {
      throw DatabaseUpdatingTaskWrongIdException();
    } catch (e) {
      throw DatabaseUpdatingTaskException('$e');
    }
  }

  @override
  Future<int> deleteAllFavourites() {
    try {
      return _database!.delete(_favouriteTableName);
    } catch (e) {
      throw DatabaseDeletingFavouritesException('$e');
    }
  }

  @override
  Future<int> deleteTaskFromFavourites(Favourite favourite) async {
    try {
      int count = await _database!.delete(_favouriteTableName,
          where: 'taskId = ?', whereArgs: [favourite.taskId]);
      if (count > 0) {
        return count;
      }
      throw DatabaseDeletingFavouriteWrongIdException();
    } on DatabaseDeletingFavouriteWrongIdException {
      throw DatabaseDeletingFavouriteWrongIdException();
    } catch (e) {
      throw DatabaseDeletingFavouriteException('$e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAllFavourites() async {
    try {
      return await _database!.query(_favouriteTableName);
    } catch (e) {
      throw DatabaseFetchingFavouritesException('$e');
    }
  }

  @override
  Future<int> insertTaskToFavourites(Favourite favourite) async {
    try {
      int id = await _database!.insert(_favouriteTableName, favourite.toJson());
      if (id != 0) {
        return id;
      }
      throw DatabaseInsertingFavouriteAlgorithmConflictException();
    } on DatabaseInsertingFavouriteAlgorithmConflictException {
      throw DatabaseInsertingFavouriteAlgorithmConflictException();
    } catch (e) {
      throw DatabaseInsertingFavouriteException('$e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTask(Task task) async {
    try {
      List<Map<String, dynamic>> data = await _database!
          .query(_taskTableName, where: 'id = ?', whereArgs: [task.id]);
      if (data.isNotEmpty) {
        return data;
      }
      throw DatabaseFetchingTaskWrongIdException();
    } on DatabaseFetchingTaskWrongIdException {
      throw DatabaseFetchingTaskWrongIdException();
    } catch (e) {
      throw DatabaseFetchingTaskException('$e');
    }
  }
}
