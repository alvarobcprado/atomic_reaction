import 'dart:async';

import 'package:atomic_reaction/atomic_reaction.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

mixin TypeAtomListenerMixin<T> on Atom<T> {
  final Map<AtomCallback<T>, StreamSubscription<T>> _atomSubscriptions = {};
  final _subscriptions = CompositeSubscription();

  void addListener(
    AtomCallback<T> listener, {
    AtomListenerModifier<T>? modifier,
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    final listenerModifier = modifier ?? (listener) => listener;

    final subscription = _subscriptions.add(
      listenerModifier(stream).listen(
        listener,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      ),
    );

    _atomSubscriptions[listener] = subscription;
  }

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

mixin VoidAtomListenerMixin on Atom<void> {
  final Map<AtomVoidCallback, StreamSubscription<void>> _atomSubscriptions = {};
  final _subscriptions = CompositeSubscription();

  void addListener(
    AtomVoidCallback listener, {
    AtomListenerModifier<void>? modifier,
    Function? onError,
    void Function()? onDone,
    bool cancelOnError = false,
  }) {
    final listenerModifier = modifier ?? (listener) => listener;
    streamListener(value) => listener();

    final subscription = _subscriptions.add(
      listenerModifier(stream).listen(
        streamListener,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      ),
    );

    _atomSubscriptions[listener] = subscription;
  }

  void removeListener(AtomVoidCallback listener) {
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
