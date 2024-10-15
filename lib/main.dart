import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => TodoListModel(), child: const TodoListApp()));
}

class TodoListApp extends StatefulWidget {
  const TodoListApp({super.key});

  @override
  State<TodoListApp> createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({
    super.key,
  });

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final todoController = TextEditingController();

  @override
  void dispose() {
    // On clean le controller quand on le retire
    todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todolist = Provider.of<TodoListModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tâches"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: todoController,
              decoration: const InputDecoration(hintText: "Nom de la tâche"),
            ),
            Expanded(
              child: ListView(
                children: todolist.todos
                    .map((t) => TodoListTile(
                        title: t.title, isCompleted: t.isCompleted))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            if (todoController.value.text != "") {
              todolist.addTodo(Todo(title: todoController.value.text));

              const snackBar = SnackBar(
                content: Text('Une tâche à été ajoutée avec succès à la liste'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }),
    );
  }
}

class TodoListTile extends StatefulWidget {
  final String title;
  final bool isCompleted;

  const TodoListTile(
      {super.key, required this.title, required this.isCompleted});

  @override
  State<TodoListTile> createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {
  @override
  Widget build(BuildContext context) {
    final todolist = Provider.of<TodoListModel>(context);

    return Dismissible(
      key: ValueKey<Key>(widget.key ?? Key("key-${DateTime.now()}")),
      onDismissed: (DismissDirection direction) {
        todolist.removeTodo(widget.title);

        const snackBar = SnackBar(
          content: Text("Une tâche a été supprimé avec succès"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      background: Container(
        color: Colors.redAccent,
      ),
      child: ListTile(
        leading: Checkbox(
          value: widget.isCompleted,
          onChanged: (value) {
            todolist.updateTodo(widget.title, !widget.isCompleted);
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(
              decoration:
                  widget.isCompleted ? TextDecoration.lineThrough : null,
              color: widget.isCompleted ? Colors.grey : null),
        ),
      ),
    );
  }
}

class Todo {
  String title;

  bool isCompleted;

  Todo({required this.title, this.isCompleted = false});
}

class TodoListModel with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void removeTodo(String title) {
    _todos.removeWhere((t) => t.title == title);
    notifyListeners();
  }

  void updateTodo(String title, bool isCompleted) {
    _todos = _todos.map((t) => t.title == title ? Todo(title: title, isCompleted: isCompleted) : t).toList();
    notifyListeners();
  }
}
