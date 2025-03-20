class AddTaskModel {
  final String taskId;
  final String title;
  final String describtion;
  final String status;
  final String statusValue;
  final String time;
  final String date;

  AddTaskModel(
    this.taskId,
    this.title,
    this.describtion,
    this.status,
    this.statusValue,
    this.time,
    this.date,
  );

  Map<String, dynamic> toMap() {
    return {
      "taskId": taskId,
      "title": title,
      "describtion": describtion,
      "status": status,
      "statusValue": statusValue,
      "time": time,
      "date": date,
    };
  }

  factory AddTaskModel.fromMap(Map<String, dynamic> data) {
    return AddTaskModel(
      data["taskId"] ?? "",
      data["title"] ?? "",
      data["describtion"] ?? "",
      data["status"] ?? "",
      data["statusValue"] ?? "",
      data["time"] ?? "",
      data["date"] ?? "",
    );
  }
}
