import 'package:flutter/material.dart';
import 'package:todo_list/todo.dart';

void main() {
  runApp(TodoListApp());
}

class TodoListApp extends StatefulWidget {
  TodoListApp({super.key});

  @override
  State<TodoListApp> createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  
  List<Todo> todos = [
    Todo(title: "Ceci est un titre", description: "Ceci est une description"),
    Todo(title: "Ceci est un deuxième titre", description: "Ceci est une deuxième description"),
  ];

  List<TodoListTile> buildTodoList() {
    List<TodoListTile> tiles = [];
    for (Todo todo in todos) {
      tiles.add(TodoListTile(title: todo.title, subtitle: todo.description));
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: buildTodoList(),
        ),
      ),
    );
  }
}

class TodoListTile extends StatefulWidget {
  final String title;
  final String subtitle;

  const TodoListTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  State<TodoListTile> createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: isCompleted,
        onChanged: (value) => {
          setState(() {
           isCompleted = !isCompleted;
          })
        },
      ),
      title: Text(
        widget.title.toString(),
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
          color: isCompleted ? Colors.grey : null
        ),
      ),
      subtitle: Text(
        widget.subtitle.toString(),
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
          color: isCompleted ? Colors.grey : null
        ),
      ),
    );
  }
}