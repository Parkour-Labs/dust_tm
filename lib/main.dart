// Copyright 2024 ParkourLabs
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:dust/dust.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:path/path.dart' as p;

import 'todo.dart';

Future<void> main() async {
  // Please ensure that you have this line before calling `Dust.open`.
  WidgetsFlutterBinding.ensureInitialized();
  // Gets the directory of the database for `dust`. `dust` currently uses
  // SQLite as the underlying database, hence we name the file `data.sqlite3`.
  final dir = await pp.getApplicationDocumentsDirectory();
  final docsPath = p.join(dir.path, 'data.sqlite3');

  // Opens the database and registers the repositories.
  Dust.open(docsPath, const [$TodoRepository()]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

/// A Reactive variable that reacts to changes and minimizes the number of
/// calculations.
///
/// Currently dust does not provide certain query methods, hence we may have to
/// read all the [Todo] nodes and filter them in Dart. This would not be as
/// efficient as doing a query with filtering, but it would be good enough for
/// most use cases in a front-end application. We are planning to implement
/// query methods in the future.
///
/// Currently, if you really want to work around this, you could try to use
/// a graph way by create a root node, and use that to query the subsequent
/// nodes. This hopefully would create a more efficient way to query the nodes.
final rootTodos = Reactive(
  (o) => Todo.all().get(o).where((t) => t.parent$.get(o) == null).toList(),
);

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: ReactiveBuilder(
        builder: (context, o) {
          /// Subscribes to the changes in the todos.
          final todos = rootTodos.get(o);
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoView(todo: todo, key: ValueKey(todo.id));
            },
          );
        },
      ),
      floatingActionButton: const CreateTodoActionButton(),
    );
  }
}

class TodoView extends ReactiveWidget {
  final Todo todo;

  const TodoView({super.key, required this.todo});

  @override
  Widget build(BuildContext context, Observer o) {
    // By passing the `Observer` `o` to the `get` method, we are subscribing to
    // the changes of that specific field.
    final title = todo.title$.get(o);
    final description = todo.description$.get(o);
    final isCompleted = todo.isCompleted$.get(o);
    // drag and drop
    return LongPressDraggable<Todo>(
      data: todo,
      feedback: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title),
        ),
      ),
      child: DragTarget<Todo>(
        builder: (context, candidateData, rejectedData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(title),
                subtitle: description != null ? Text(description) : null,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => TodoCreateOrEditDialog(
                      todo: todo,
                      key: ValueKey(todo.id),
                      isCreate: false,
                    ),
                  );
                },
                trailing: Checkbox(
                  value: isCompleted,
                  onChanged: (value) {
                    if (value == null) return;
                    todo.isCompleted = value;
                  },
                ),
              ),
              if (todo.children$.get(o).isNotEmpty) TagChildren(todo: todo),
            ],
          );
        },
        onAcceptWithDetails: (details) {
          final data = details.data;
          if (todo.isDescendentOf(data) || todo.id == data.id) return;
          data.parent$.set(todo);
        },
      ),
    );
  }
}

class TagChildren extends StatelessWidget {
  const TagChildren({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ReactiveBuilder(builder: (context, o) {
            return Column(
              children: [
                for (final child in todo.children$.get(o))
                  TodoView(todo: child, key: ValueKey(child.id)),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class CreateTodoActionButton extends StatelessWidget {
  const CreateTodoActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // this will create a new todo automatically and save it to the
        // persistent storage and notifies all the relevant UIs to change.
        final todo = Todo(title: '', isCompleted: false);
        // show dialog
        final val = await showDialog<Todo?>(
          context: context,
          builder: (context) => TodoCreateOrEditDialog(todo: todo),
        );
        if (val != null) return;
        // if we did not press ok, then we want to remove the todo.
        todo.delete();
      },
      tooltip: 'Create Todo',
      child: const Icon(Icons.add),
    );
  }
}

class TodoCreateOrEditDialog extends StatelessWidget {
  const TodoCreateOrEditDialog({
    super.key,
    required this.todo,
    this.isCreate = true,
  });

  final Todo todo;

  final bool isCreate;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Create Todo'),
      contentPadding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          initialValue: todo.title$.get(null),
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (val) {
            todo.title$.set(val);
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: todo.description$.get(null),
          decoration: const InputDecoration(labelText: 'Description'),
          onChanged: (val) {
            if (val.isEmpty) {
              todo.description$.set(null);
              return;
            }
            todo.description$.set(val);
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: () {
                todo.delete();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
            const Spacer(),
            FilledButton.tonal(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(todo),
              child: isCreate ? const Text('Create') : const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
