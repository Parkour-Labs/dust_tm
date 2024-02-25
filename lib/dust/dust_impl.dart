import 'dart:async';
import 'package:dust/dust.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:path/path.dart' as p;
import '../main.dart';
import 'todo.dart';
import 'ui.dart';

final class DustImpl implements Impl {
  @override
  final Widget home = const MyHomePage();

  @override
  FutureOr<void> init() async {
    // Gets the directory of the database for `dust`. `dust` currently uses
    // SQLite as the underlying database, hence we name the file `data.sqlite3`.
    final dir = await pp.getApplicationDocumentsDirectory();
    final docsPath = p.join(dir.path, 'data.sqlite3');

    // Opens the database and registers the repositories.
    Dust.open(docsPath, const [$TodoRepository()]);
  }

  @override
  Future<(Duration, Duration, Duration)> benchmark(int num) async {
    final stopWatch = Stopwatch();
    stopWatch.start();
    for (var i = 0; i < num; i++) {
      Todo(
        title: 'Todo $i',
        isCompleted: false,
      );
    }
    stopWatch.stop();
    final createTime = stopWatch.elapsed;
    stopWatch.reset();
    stopWatch.start();
    final todos = const $TodoRepository().all().get(null);
    stopWatch.stop();
    final listTime = stopWatch.elapsed;
    stopWatch.reset();
    stopWatch.start();
    for (var todo in todos) {
      todo.delete();
    }
    stopWatch.stop();
    final deleteTime = stopWatch.elapsed;
    return (createTime, listTime, deleteTime);
  }
}
