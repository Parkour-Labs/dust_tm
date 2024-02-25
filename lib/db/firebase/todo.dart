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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
class Todo with _$Todo {
  const Todo._();

  const factory Todo({
    required String id,
    required String title,
    String? description,
    required bool isCompleted,
    String? parentId,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  static Future<Todo?> fromId(String id) async {
    final docs = FirebaseFirestore.instance.collection('todos');
    final doc = await docs.doc(id).get();
    final data = doc.data();
    if (data == null) return null;
    try {
      return Todo.fromJson(data);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return null;
    }
  }

  Future<void> save() async {
    final docs = FirebaseFirestore.instance.collection('todos');
    await docs.doc(id).set(toJson());
  }

  Future<void> delete() async {
    final docs = FirebaseFirestore.instance.collection('todos');
    await docs.doc(id).delete();
  }

  Future<Todo> toggle() async {
    final docs = FirebaseFirestore.instance.collection('todos');
    await docs.doc(id).update({'isCompleted': !isCompleted});
    return copyWith(isCompleted: !isCompleted);
  }

  Future<bool> isDescendentOf(Todo other) async {
    String? p = parentId;
    while (p != null) {
      if (p == other.id) return true;
      p = (await fromId(p))?.parentId;
    }
    return false;
  }

  Future<Todo> setIsCompleted(bool value) async {
    final docs = FirebaseFirestore.instance.collection('todos');
    await docs.doc(id).update({'isCompleted': value});
    return copyWith(isCompleted: value);
  }

  Future<List<Todo>> listChildren() async {
    final docs = FirebaseFirestore.instance.collection('todos');
    final query = await docs.where('parentId', isEqualTo: id).get();
    return query.docs.map((e) => Todo.fromJson(e.data())).toList();
  }

  Future<Todo> setParent(Todo? parent) async {
    final docs = FirebaseFirestore.instance.collection('todos');
    await docs.doc(id).update({'parentId': parent?.id});
    return copyWith(parentId: parent?.id);
  }

  static Future<List<Todo>> listRoots() async {
    final docs = FirebaseFirestore.instance.collection('todos');
    final query = await docs.where('parentId', isNull: true).get();
    return query.docs.map((e) => Todo.fromJson(e.data())).toList();
  }
}
