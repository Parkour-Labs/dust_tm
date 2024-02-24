// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// ModelRepositoryGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, unused_local_variable, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types
// coverage:ignore-file

mixin _$Todo {
  Id get id;
  Atom<String> get title$;
  AtomOption<String?> get description$;
  Atom<bool> get isCompleted$;
  LinkOption<Todo?> get parent$;
  Backlinks<Todo> get children$;

  void delete();
}

final class _Todo extends Todo {
  @override
  final Id id;

  _Todo._(this.id,
      {required this.title$,
      required this.description$,
      required this.isCompleted$,
      required this.parent$,
      required this.children$})
      : super._();

  factory _Todo({
    required String title,
    String? description,
    required bool isCompleted,
    Todo? parent,
    Iterable<Todo> children = const Iterable.empty(),
  }) {
    assert(
      children.isEmpty,
      'Backlink children in constructor currently does not support passing in any arguments, but only serve as a marker parameter.',
    );

    return const $TodoRepository().create(
      title: title,
      description: description,
      isCompleted: isCompleted,
      parent: parent,
      children: children,
    ) as _Todo;
  }

  @override
  final Atom<String> title$;

  @override
  final AtomOption<String?> description$;

  @override
  final Atom<bool> isCompleted$;

  @override
  final LinkOption<Todo?> parent$;

  @override
  final Backlinks<Todo> children$;

  @override
  void delete() => const $TodoRepository().delete(this);
}

class $TodoRepository implements Repository<Todo> {
  const $TodoRepository();

  static const int Label = 8512415165397905237;
  static const int titleLabel = -5241206623633058639;
  static const int descriptionLabel = -6800137541873066883;
  static const int isCompletedLabel = -7402738807038578080;
  static const int parentLabel = 5925104734870249561;

  static const titleSerializer = StringSerializer();
  static const descriptionSerializer = OptionSerializer(StringSerializer());
  static const isCompletedSerializer = BoolSerializer();

  static final Map<Id, WeakReference<NodeOption<Todo>>> $entries = {};

  static bool $init = false;

  @override
  Schema init() {
    $init = true;
    return const Schema(
      stickyNodes: [$TodoRepository.Label],
      stickyAtoms: [
        $TodoRepository.titleLabel,
        $TodoRepository.isCompletedLabel
      ],
      stickyEdges: [],
      acyclicEdges: [],
    );
  }

  @override
  Id id(Todo $model) => $model.id;

  void $write(
    Id $id, {
    required String title,
    String? description,
    required bool isCompleted,
    Todo? parent,
  }) {
    assert($init, 'Repository should be registered in `Dust.open`.');
    final $store = Dust.instance;
    $store.setNode($id, $TodoRepository.Label);
    $store.setAtom(
      $id ^ $TodoRepository.titleLabel,
      (
        $id,
        $TodoRepository.titleLabel,
        title,
        $TodoRepository.titleSerializer,
      ),
    );

    if (description != null) {
      $store.setAtom(
        $id ^ $TodoRepository.descriptionLabel,
        (
          $id,
          $TodoRepository.descriptionLabel,
          description,
          $TodoRepository.descriptionSerializer,
        ),
      );
    }

    $store.setAtom(
      $id ^ $TodoRepository.isCompletedLabel,
      (
        $id,
        $TodoRepository.isCompletedLabel,
        isCompleted,
        $TodoRepository.isCompletedSerializer,
      ),
    );

    if (parent != null) {
      $store.setEdge(
        $id ^ $TodoRepository.parentLabel,
        (
          $id,
          $TodoRepository.parentLabel,
          parent.id,
        ),
      );
    }

    $store.barrier();
  }

  Todo create({
    required String title,
    String? description,
    required bool isCompleted,
    Todo? parent,
    Iterable<Todo> children = const Iterable.empty(),
  }) {
    final $id = Dust.instance.randomId();
    final $node = get($id);
    $write(
      $id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      parent: parent,
    );
    final $res = $node.get(null)!;

    return $res;
  }

  NodeAuto<Todo> auto(
    Id $id, {
    required String title,
    String? description,
    required bool isCompleted,
    Todo? parent,
    Iterable<Todo> children = const Iterable.empty(),
  }) {
    final $node = get($id);
    return NodeAuto(
      $node,
      () => $write(
        $id,
        title: title,
        description: description,
        isCompleted: isCompleted,
        parent: parent,
      ),
      ($res) {},
    );
  }

  @override
  NodeOption<Todo> get(Id $id) {
    final $existing = $entries[$id]?.target;
    if ($existing != null) return $existing;
    final $model = _Todo._(
      $id,
      title$: Atom<String>(
        $id ^ $TodoRepository.titleLabel,
        $id,
        $TodoRepository.titleLabel,
        $TodoRepository.titleSerializer,
      ),
      description$: AtomOption<String?>(
        $id ^ $TodoRepository.descriptionLabel,
        $id,
        $TodoRepository.descriptionLabel,
        $TodoRepository.descriptionSerializer,
      ),
      isCompleted$: Atom<bool>(
        $id ^ $TodoRepository.isCompletedLabel,
        $id,
        $TodoRepository.isCompletedLabel,
        $TodoRepository.isCompletedSerializer,
      ),
      parent$: LinkOption<Todo?>(
        $id ^ $TodoRepository.parentLabel,
        $id,
        $TodoRepository.parentLabel,
        const $TodoRepository(),
      ),
      children$: Backlinks<Todo>(
        $id,
        $TodoRepository.parentLabel,
        const $TodoRepository(),
      ),
    );
    final $entry = NodeOption($id, $TodoRepository.Label, $model);
    $entries[$id] = WeakReference($entry);
    return $entry;
  }

  @override
  void delete(Todo $model) {
    assert($init, 'Repository should be registered in `Dust.open`.');
    final $id = $model.id;
    final $store = Dust.instance;
    $entries.remove($id);
    $store.setNode($id, null);
    $store.barrier();
  }

  NodesByLabel<Todo> all() =>
      NodesByLabel($TodoRepository.Label, const $TodoRepository());
}
