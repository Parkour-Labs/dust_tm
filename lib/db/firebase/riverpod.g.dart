// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rootTodosHash() => r'e23bc9b9b791a312333d5876c1439d439eaeb338';

/// See also [rootTodos].
@ProviderFor(rootTodos)
final rootTodosProvider = AutoDisposeFutureProvider<List<Todo>>.internal(
  rootTodos,
  name: r'rootTodosProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rootTodosHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RootTodosRef = AutoDisposeFutureProviderRef<List<Todo>>;
String _$childrenOfHash() => r'ab912757e6325c9560df0ca654b55287bff2f015';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [childrenOf].
@ProviderFor(childrenOf)
const childrenOfProvider = ChildrenOfFamily();

/// See also [childrenOf].
class ChildrenOfFamily extends Family<AsyncValue<List<Todo>>> {
  /// See also [childrenOf].
  const ChildrenOfFamily();

  /// See also [childrenOf].
  ChildrenOfProvider call(
    Todo todo,
  ) {
    return ChildrenOfProvider(
      todo,
    );
  }

  @override
  ChildrenOfProvider getProviderOverride(
    covariant ChildrenOfProvider provider,
  ) {
    return call(
      provider.todo,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'childrenOfProvider';
}

/// See also [childrenOf].
class ChildrenOfProvider extends AutoDisposeFutureProvider<List<Todo>> {
  /// See also [childrenOf].
  ChildrenOfProvider(
    Todo todo,
  ) : this._internal(
          (ref) => childrenOf(
            ref as ChildrenOfRef,
            todo,
          ),
          from: childrenOfProvider,
          name: r'childrenOfProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$childrenOfHash,
          dependencies: ChildrenOfFamily._dependencies,
          allTransitiveDependencies:
              ChildrenOfFamily._allTransitiveDependencies,
          todo: todo,
        );

  ChildrenOfProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.todo,
  }) : super.internal();

  final Todo todo;

  @override
  Override overrideWith(
    FutureOr<List<Todo>> Function(ChildrenOfRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChildrenOfProvider._internal(
        (ref) => create(ref as ChildrenOfRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        todo: todo,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Todo>> createElement() {
    return _ChildrenOfProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChildrenOfProvider && other.todo == todo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, todo.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChildrenOfRef on AutoDisposeFutureProviderRef<List<Todo>> {
  /// The parameter `todo` of this provider.
  Todo get todo;
}

class _ChildrenOfProviderElement
    extends AutoDisposeFutureProviderElement<List<Todo>> with ChildrenOfRef {
  _ChildrenOfProviderElement(super.provider);

  @override
  Todo get todo => (origin as ChildrenOfProvider).todo;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
