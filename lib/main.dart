import 'package:flutter/material.dart';
import 'package:todo_list/todo.dart';

void main() {
  runApp(const TodoListApp());
}

class TodoListApp extends StatefulWidget {
  const TodoListApp({super.key});

  @override
  State<TodoListApp> createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainRoute(),
    );
  }
}

class MainRoute extends StatelessWidget {
  MainRoute({
    super.key,
  });

  final List<Todo> todos = [
    Todo(title: "Ceci est un titre ", description: "Ceci est une description"),
    Todo(title: "Ceci est un deuxième titre", description: "Ceci est une deuxième description"),
  ];

  List<TodoListTile> buildTodoList() {
    List<TodoListTile> tiles = [];
    for (var i = 0; i < todos.length; i++) {
      Todo todo = todos[i];
      todo.isCompleted = true;
      tiles.add(TodoListTile(title: todo.title, subtitle: todo.description, todos: todos, todoIndex: i, ));
    }
    return tiles;
  }

  void displayTodo(Todo todo) {
    print("Titre: ${todo.title}, Description ${todo.description}, isCompleted: ${todo.isCompleted}, dueDate: ${todo.dueDate}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tâches"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: buildTodoList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Créer une nouvelle tâche"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateTodoRoute())
          );
        }
      ),
    );
  }
}

class CreateTodoRoute extends StatefulWidget {
  const CreateTodoRoute({
    super.key,
  });

  @override
  State<CreateTodoRoute> createState() => _CreateTodoRouteState();
}

class _CreateTodoRouteState extends State<CreateTodoRoute> {

  final todoNameController = TextEditingController();
  final todoDescriptionController = TextEditingController();
  DateTime? todoDueDateValue;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer une nouvelle tâche"),
      ),
      body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: TextField(
                controller: todoNameController,
                decoration: const InputDecoration(
                  hintText: "Tâche à réaliser"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: TextField(
                controller: todoDescriptionController,
                decoration: const InputDecoration(
                  fillColor: Colors.red,
                  hintText: "Description de la tâche à réaliser"
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "Date d'échéance",
                style: TextStyle(
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
            CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              onDateChanged: (value) {
                print(value);
                todoDueDateValue = value;
              }
            ),
            Center(
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  print("Nouvelle tâche: ${todoNameController.value.text}, Description: ${todoDescriptionController.value.text}, Échéance: $todoDueDateValue");
                }
              ),
            )
          ],
        ),
    );
  }
}

class TodoListTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final int todoIndex;
  final List<Todo> todos;

  const TodoListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.todoIndex,
    required this.todos
  });

  @override
  State<TodoListTile> createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {

  void displayTodo(Todo todo) {
    print("Titre: ${todo.title}, Description ${todo.description}, isCompleted: ${todo.isCompleted}, dueDate: ${todo.dueDate}");
  }

  @override
  Widget build(BuildContext context) {
    Todo t = widget.todos[widget.todoIndex];
    displayTodo(t);

    return ListTile(      
      leading: Checkbox(
        value: widget.todos[widget.todoIndex].isCompleted,
        onChanged: (value) => {
          setState(() {
           widget.todos[widget.todoIndex].isCompleted = !widget.todos[widget.todoIndex].isCompleted;
          })
        },
      ),
      title: Text(
        widget.title.toString(),
        style: TextStyle(
          decoration: widget.todos[widget.todoIndex].isCompleted ? TextDecoration.lineThrough : null,
          color: widget.todos[widget.todoIndex].isCompleted ? Colors.grey : null
        ),
      ),
      subtitle: Text(
        widget.subtitle.toString(),
        style: TextStyle(
          decoration: widget.todos[widget.todoIndex].isCompleted ? TextDecoration.lineThrough : null,
          color: widget.todos[widget.todoIndex].isCompleted ? Colors.grey : null
        ),
      ),
    );
  }
}