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

part 'todo.dust.dart';

@Model()
abstract class Todo with _$Todo {
  Todo._();

  factory Todo({
    required String title,
    String? description,
    required bool isCompleted,
    @Ln() Todo? parent,
    @Ln(backTo: 'parent') List<Todo> children,
  }) = _Todo;

  /// Lists all the [Todo] nodes.
  static NodesByLabel<Todo> all() => const $TodoRepository().all();

  /// Returns true if [this] [Todo] is a descendant of [other], meaning that
  /// [other] is either the parent of [this], or the parent of the parent of
  /// [this], and so on.
  bool isDescendentOf(Todo other) {
    var p = parent$.get(null);
    while (p != null) {
      if (p == other) return true;
      p = p.parent$.get(null);
    }
    return false;
  }

  /// Toggles the [isCompleted] state of this [Todo].
  void toggle() {
    isCompleted$.set(!isCompleted$.get(null));
  }

  set isCompleted(bool value) => isCompleted$.set(value);
}

