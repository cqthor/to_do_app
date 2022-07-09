class Task {
  int? id;
  late String name;
  late bool isFinished;
  late bool isSelected;
  List<SubTasks>? subTasks;
  late bool isEditing;
  late bool isAdding;
  Task({
    this.id,
    required this.name,
    required this.isFinished,
    this.subTasks,
    this.isSelected = false,
    this.isEditing = false,
    this.isAdding = false,
  });
}

class SubTasks {
  int? id;
  late String name;
  late bool isFinished;
  late bool isEditing;
  SubTasks(
      {this.id,
      required this.name,
      required this.isFinished,
      this.isEditing = false});
}
