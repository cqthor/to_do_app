class Task {
  int? id;
  final String name;
  late bool isFinished;
  late bool isSelected;
  List<SubTasks>? subTasks;
  Task({
    this.id,
    required this.name,
    required this.isFinished,
    this.subTasks,
    this.isSelected = false,
  });
}

class SubTasks {
  int? id;
  final String name;
  late bool isFinished;

  SubTasks({this.id, required this.name, required this.isFinished});
}
