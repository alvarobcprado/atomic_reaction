import 'dart:async';

import 'package:atomic_reaction/atomic_reaction.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

/// {@template atom_listener_mixin}
/// A mixin that helps with adding listeners to an [Atom].
/// {@endtemplate}
mixin TypeAtomListenerMixin<T> on Atom<T> {
  final Map<AtomCallback<T>, StreamSubscription<T>> _atomSubscriptions = {};
  final _subscriptions = CompositeSubscription();

  /// {@template atom_add_listener}
  /// Adds a callback that will be called whenever the [Atom] changes.
  /// {@endtemplate}
  void addListener(
    AtomCallback<T> listener, {
    AtomListenerModifier<T>? modifier,
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    final listenerModifier = modifier ?? (listener) => listener;

    _atomSubscriptions[listener] = _subscriptions.add(
      listenerModifier(stream).listen(
        listener,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      ),
    );
  }

  /// {@template atom_remove_listener}
  /// Removes the given [listener] from the list of listeners and cancels its
  /// subscription.
  /// {@endtemplate}
  void removeListener(AtomCallback<T> listener) {
    final subscription = _atomSubscriptions.remove(listener);
    subscription?.cancel();
  }

  @override
  @mustCallSuper
  void dispose() {
    for (final subscription in _atomSubscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.dispose();
  }
}
