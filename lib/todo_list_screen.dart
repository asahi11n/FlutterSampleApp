
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'database_helper.dart';
import 'todo_edit_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _refreshTodoList();
  }

  Future<void> _refreshTodoList() async {
    final todos = await DatabaseHelper.instance.readAllTodos();
    setState(() {
      _todos = todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODOメモアプリ'),
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return ListTile(
            title: Text(todo.title),
            subtitle: Text(todo.date),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TodoEditScreen(todo: todo),
                ),
              );
              _refreshTodoList();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TodoEditScreen(),
            ),
          );
          _refreshTodoList();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
