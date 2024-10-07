import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return const MaterialApp(
      home: MainRoute(),
    );
  }
}

class MainRoute extends StatefulWidget {
  const MainRoute({
    super.key,
  });

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  final todoController = TextEditingController();

  @override
  void dispose() {
    // On clean le controller quand on le retire
    todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return FutureBuilder<List<TodoListTile>>(
        future: TodoService.buildTodoList(),
        builder: (context, AsyncSnapshot<List<TodoListTile>> snapshot) {
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
                    decoration: const InputDecoration(
                      hintText: "Nom de la tâche"
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: snapshot.data ?? [],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                if (todoController.value.text != "") {
                  TodoService.addTodo(todoController.value.text);
                
                  const snackBar = SnackBar(
                    content: Text('Une tâche à été ajoutée avec succès à la liste'),
                  );
            
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }

                setState(() {});
              }
            ),
          );
        }
      );
  }
}

class TodoListTile extends StatefulWidget {
  final String title;
  bool isCompleted;

  TodoListTile({
    super.key,
    required this.title,
    required this.isCompleted
  });

  @override
  State<TodoListTile> createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<Key>(widget.key ?? Key("key-${DateTime.now()}")),
      onDismissed: (DismissDirection direction) {
        TodoService.removeTodo(widget.title);

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
          onChanged: (value) async {
            await TodoService.updateTodo(widget.title, !widget.isCompleted);
            setState(() {
              widget.isCompleted = !widget.isCompleted;
            });
          },
        ),
        title: Text(
          widget.title.toString(),
          style: TextStyle(
            decoration: widget.isCompleted ? TextDecoration.lineThrough : null,
            color: widget.isCompleted ? Colors.grey : null
          ),
        ),
      ),
    );
  }
}

class TodoService {
  static Future<List<TodoListTile>> buildTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // on crée une nouvelle liste de widget tâches
    List<TodoListTile> tiles = [];
    // on récupère la liste des todos existants
    final List<String>? todos = prefs.getStringList("todos");
    // on récupère la longueur de cette liste de todos
    final int todosLength = todos?.length ?? 0;
    for (var i = 0; i < todosLength; i++) {
      String todo = todos?[i] ?? "";
      final bool? isCompleted = prefs.getBool(todo);
      // on ajoute la tile dans la liste des wigdgets
      tiles.add(TodoListTile(title: todo, isCompleted: isCompleted ?? false,));
    }
    return tiles;
  }

  static Future<void> removeTodo(String todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // on récupère tous les todos 
    List<String>? todos = prefs.getStringList("todos");
    // on supprime le todo de la liste
    todos?.remove(todo);
    // on supprime le todo et son état
    await prefs.remove(todo);
    // on met à jour la liste de tous les todos
    await prefs.setStringList("todos", todos ?? []);
  }

  static Future<void> addTodo(String todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // on récupère tous les todos 
    List<String> todos = prefs.getStringList("todos") ?? [];
    // on ajoute le todo à la liste des todos
    todos.add(todo);
    // on met à jour les todos de manière globale
    await prefs.setStringList("todos", todos);
    // on met à jour seulement le todo correspondant
    await prefs.setBool(todo, false);
  }

  static Future<void> updateTodo(String todo, bool isCompleted) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // on met à jour le todo correspondant
    await prefs.setBool(todo, isCompleted);
  }
}