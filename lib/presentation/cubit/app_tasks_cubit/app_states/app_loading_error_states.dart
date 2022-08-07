import '../app_cubit.dart';

class AppDatabasePathLoadingErrorState extends AppState {}

class AppDatabasePathLoadingEmptyValueErrorState extends AppState {}

class AppDatabaseTaskTableCreatingErrorState extends AppState {}

class AppDatabaseFavouriteTableCreatingErrorState extends AppState {}

class AppDatabaseInitializingErrorState extends AppState {}

class AppDatabaseTaskInsertingErrorState extends AppState {}

class AppDatabaseTaskInsertingAlgorithmConflictErrorState extends AppState {}

class AppDatabaseTaskUpdatingErrorState extends AppState {}

class AppDatabaseTaskUpdatingWrongIdErrorState extends AppState {}

class AppDatabaseTasksFetchingErrorState extends AppState {}

class AppDatabaseTaskDeletingWrongIdErrorState extends AppState {}

class AppDatabaseTaskDeletingErrorState extends AppState {}

class AppDatabaseTasksDeletingErrorState extends AppState {}

class AppDatabaseFavouritesFetchingErrorState extends AppState {}

class AppDatabaseFavouritesDeletingErrorState extends AppState {}

class AppDatabaseFavouritesTaskInsertingErrorState extends AppState {}

class AppDatabaseFavouritesTaskDeletingWrongIdErrorState extends AppState {}

class AppDatabaseFavouritesTaskDeletingErrorState extends AppState {}

class AppDatabaseFavouritesTaskInsertingAlgorithmConflictErrorState
    extends AppState {}

class AppDatabaseFetchingTaskErrorState extends AppState {}

class AppDatabaseFetchingTaskWrongIdErrorState extends AppState {}

class AppNotificationInitializingErrorState extends AppState {}

class AppNotificationInitializingFalseOrNullValueErrorState extends AppState {}

class AppNotificationIOSPermissionError extends AppState {}

class AppNotificationIOSPermissionNotGrantedOrNullErrorState extends AppState {}

class AppNotificationTimeZoneErrorState extends AppState {}

class AppNotificationSchedulingErrorState extends AppState {}

class AppNotificationRepeatingErrorState extends AppState {}

class AppNotificationCancelingErrorState extends AppState {}

class AppNotificationAllNotificationCancelingErrorState extends AppState {}

class AppNotificationWorkManagerInitializationErrorState extends AppState {}

class AppNotificationWorkManagerRepeatTaskErrorState extends AppState {}

class AppNotificationWorkManagerCancelingTaskByUniqueNameErrorState
    extends AppState {}

class AppNotificationWorkManagerCancelingAllTasksErrorState extends AppState {}
