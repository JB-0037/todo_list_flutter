class Todo {
  late String title;
  late String description;
  late bool isCompleted;
  DateTime? dueDate;

  Todo({required this.title, required this.description, this.dueDate}) {
    isCompleted = false;
  }
}