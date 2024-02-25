import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../main.dart';
import 'firebase_options.dart';
import 'todo.dart';
import 'package:uuid/uuid.dart';
part 'riverpod.g.dart';

final class FirebaseRiverpodImpl implements Impl {
  @override
  Widget get home => const MyHomePage();

  @override
  FutureOr<void> init() async {
    debugPrint('Initializing Firebase');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Initialized Firebase');
  }

  @override
  Future<(Duration, Duration, Duration)> benchmark(int num) async {
    final stopWatch = Stopwatch();
    debugPrint('Creating $num todos');
    stopWatch.start();
    final batch = FirebaseFirestore.instance.batch();
    for (var i = 0; i < num; i++) {
      final todo = Todo(
        id: const Uuid().v4(),
        title: 'Todo $i',
        isCompleted: false,
      );
      batch.set(
        FirebaseFirestore.instance.collection('todos').doc(todo.id),
        todo.toJson(),
      );
    }
    await batch.commit();
    stopWatch.stop();
    final createTime = stopWatch.elapsed;
    debugPrint('Created $num todos in $createTime');
    stopWatch.reset();
    debugPrint('Listing all todos');
    stopWatch.start();
    final listed = await Todo.listRoots();
    stopWatch.stop();
    final listTime = stopWatch.elapsed;
    debugPrint('Listed all todos in $listTime');
    stopWatch.reset();
    debugPrint('Deleting all todos');
    stopWatch.start();
    final deleteBatch = FirebaseFirestore.instance.batch();
    for (var todo in listed) {
      deleteBatch
          .delete(FirebaseFirestore.instance.collection('todos').doc(todo.id));
    }
    await deleteBatch.commit();
    stopWatch.stop();
    final deleteTime = stopWatch.elapsed;
    debugPrint('Deleted all todos in $deleteTime');
    return (createTime, listTime, deleteTime);
  }
}

@riverpod
Future<List<Todo>> rootTodos(RootTodosRef ref) {
  return Todo.listRoots();
}

@riverpod
Future<List<Todo>> childrenOf(ChildrenOfRef ref, Todo todo) {
  return todo.listChildren();
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          /// Subscribes to the changes in the todos.
          final todos = ref.watch(rootTodosProvider);
          return todos.when(
            data: (todos) {
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return TodoView(todo: todo, key: ValueKey(todo.id));
                },
              );
            },
            error: (error, stackTrace) {
              return Center(
                child: Text('Error: $error'),
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
      floatingActionButton: const CreateTodoActionButton(),
    );
  }
}

class TodoView extends ConsumerWidget {
  final Todo todo;

  const TodoView({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // By passing the `Observer` `o` to the `get` method, we are subscribing to
    // the changes of that specific field.
    final todo = useState(this.todo);
    final title = todo.value.title;
    final description = todo.value.description;
    final isCompleted = todo.value.isCompleted;
    // drag and drop
    return LongPressDraggable<Todo>(
      data: todo.value,
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
                onTap: () async {
                  final td = await showDialog(
                    context: context,
                    builder: (context) => TodoCreateOrEditDialog(
                      todo: todo.value,
                      key: ValueKey(todo.value.id),
                      isCreate: false,
                    ),
                  );
                  if (td == null) return;
                  todo.value = td;
                  await td.save();
                },
                trailing: Checkbox(
                  value: isCompleted,
                  onChanged: (value) async {
                    if (value == null) return;
                    todo.value = await todo.value.setIsCompleted(value);
                  },
                ),
              ),
              TagChildren(todo: todo.value)
            ],
          );
        },
        onAcceptWithDetails: (details) {
          final data = details.data;
          if (todo.value.id == data.id) return;
          todo.value.isDescendentOf(data).then((isDescendent) async {
            if (isDescendent) return;
            todo.value = await todo.value.setParent(data);
          });
        },
      ),
    );
  }
}

class TagChildren extends ConsumerWidget {
  const TagChildren({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = ref.watch(childrenOfProvider(todo));
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
          child: children.when(
            data: (todos) {
              return Column(
                children: [
                  for (final todo in todos)
                    TodoView(todo: todo, key: ValueKey(todo.id)),
                ],
              );
            },
            error: (error, stackTrace) {
              return Text('Error: $error');
            },
            loading: () => const CircularProgressIndicator(),
          ),
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
        final val = await showDialog<Todo?>(
          context: context,
          builder: (context) => const TodoCreateOrEditDialog(),
        );
        if (val != null) await val.save();
        // if we did not press ok, then we want to remove the todo.
      },
      tooltip: 'Create Todo',
      child: const Icon(Icons.add),
    );
  }
}

class TodoCreateOrEditDialog extends StatelessWidget {
  const TodoCreateOrEditDialog({
    super.key,
    this.todo,
    this.isCreate = true,
  });

  final Todo? todo;

  final bool isCreate;

  @override
  Widget build(BuildContext context) {
    final todo = useRef(this.todo ??
        Todo(id: const Uuid().v4(), title: '', isCompleted: false));
    return SimpleDialog(
      title: const Text('Create Todo'),
      contentPadding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          initialValue: todo.value.title,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (val) {
            todo.value = todo.value.copyWith(title: val);
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: todo.value.description,
          decoration: const InputDecoration(labelText: 'Description'),
          onChanged: (val) {
            if (val.isEmpty) {
              todo.value = todo.value.copyWith(description: null);
              return;
            }
            todo.value = todo.value.copyWith(description: val);
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: () {
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
