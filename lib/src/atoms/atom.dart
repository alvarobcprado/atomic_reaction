import 'dart:async';

import 'package:atomic_reaction/src/utils/listener_mixin.dart';
import 'package:rxdart/rxdart.dart';

part './action_atom.dart';
part './state_atom.dart';

abstract class Atom<T> {
  const Atom(this._subject);

  final Subject<T> _subject;

  Stream<T> get stream => _subject;

  void dispose();
}
