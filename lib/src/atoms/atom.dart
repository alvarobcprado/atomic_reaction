import 'dart:async';

import 'package:atomic_reaction/src/listener/listener_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

part './action_atom.dart';
part './event_atom.dart';
part './state_atom.dart';

/// {@template atom}
/// An abstract class representing an atom.
///
/// An atom is a fundamental unit in the atomic_reaction library.
/// It provides a stream of values of type [T] and can be disposed when no
/// longer needed.
/// {@endtemplate}
abstract class Atom<T> {
  /// {@macro atom}
  const Atom(this._subject);

  final Subject<T> _subject;

  /// The stream of values emitted by the atom.
  Stream<T> get stream => _subject;

  /// Whether the atom is closed.
  bool get isClosed => _subject.isClosed;

  /// Disposes the atom, releasing any resources associated with it.
  @mustCallSuper
  void dispose() {
    _subject.close();
  }
}
