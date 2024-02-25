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

import 'dart:async';

import 'package:flutter/material.dart';

import 'dust/dust_impl.dart';

Future<void> main() async {
  // Please ensure that you have this line before calling `Dust.open`.
  WidgetsFlutterBinding.ensureInitialized();

  final impl = DustImpl();

  await impl.init();

  final (start, list, delete) = await impl.benchmark(10000);

  debugPrint('Create: $start');
  debugPrint('List:   $list');
  debugPrint('Delete: $delete');

  runApp(MyApp(impl: impl));
}

abstract interface class Impl {
  /// Initializes the application.
  FutureOr<void> init();

  /// The home widget of the application.
  Widget get home;

  /// Benchmarks the creation, list all, and deletion times of [num] todos.
  Future<(Duration, Duration, Duration)> benchmark(int num);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.impl});

  final Impl impl;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: impl.home,
    );
  }
}
