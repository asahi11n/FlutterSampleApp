
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'database_helper.dart';

class TodoEditScreen extends StatefulWidget {
  final Todo? todo;

  const TodoEditScreen({Key? key, this.todo}) : super(key: key);

  @override
  State<TodoEditScreen> createState() => _TodoEditScreenState();
}

class _TodoEditScreenState extends State<TodoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
    _title = widget.todo?.title ?? '';
    _content = widget.todo?.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? '新しいTODO' : 'TODOを編集'),
        actions: [
          if (widget.todo != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await DatabaseHelper.instance.delete(widget.todo!.id!);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'タイトル'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'タイトルを入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _content,
                decoration: const InputDecoration(labelText: '内容'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '内容を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value!;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  print("!!!! 保存ボタンが押されました");
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final now = DateTime.now();
                    final formatter = DateFormat('yyyy/MM/dd HH:mm');
                    final date = formatter.format(now);
                    final todo = Todo(
                      id: widget.todo?.id,
                      title: _title,
                      content: _content,
                      date: date,
                    );
                    if (widget.todo == null) {
                      await DatabaseHelper.instance.create(todo);
                    } else {
                      await DatabaseHelper.instance.update(todo);
                    }
                    Navigator.of(context).pop();
                  } else {
                    print("!!!! else");
                  }
                },
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
