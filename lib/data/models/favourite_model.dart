class Favourite {
  final String taskId;

  Favourite({required this.taskId});

  Map<String, dynamic> toJson() => {
        'taskId': taskId,
      };

  Favourite.fromJson(Map<String, dynamic> json)
      : taskId = json['taskId'] as String;
}
