import 'dart:async';

import 'package:atomic_reaction/src/utils/typedefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

abstract class Atom<T> {
  Stream<T> get stream;
  void call(T value);

  final Map<AtomCallback<T>, StreamSubscription<T>> _atomSubscriptions = {};
  final _subscriptions = CompositeSubscription();

  void listenAtom(
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

  void removeAtomListener(AtomCallback<T> listener) {
    final subscription = _atomSubscriptions.remove(listener);
    subscription?.cancel();
  }

  @mustCallSuper
  void dispose() {
    for (final subscription in _atomSubscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.dispose();
  }
}
