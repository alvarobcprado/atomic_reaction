part of './atom.dart';

/// {@template state_atom}
/// A [StateAtom] is the smallest unit of state with type [S] in the
/// application.
/// It is a simple wrapper around a [BehaviorSubject] that allows
/// you to get and set the value [S] of the [StateAtom] and listen to changes.
/// {@endtemplate}
final class StateAtom<S> extends Atom<S> with TypeAtomListenerMixin<S> {
  /// {@macro state_atom}
  StateAtom(S value) : super(BehaviorSubject<S>.seeded(value));

  BehaviorSubject<S> get _stateSubject => _subject as BehaviorSubject<S>;

  /// Sets the value of the state atom.
  ///
  /// Updates the value of the state atom and notifies any subscribers.
  ///
  /// Usage:
  /// ```dart
  /// stateAtom.value = newValue;
  /// ```
  set value(S value) {
    _stateSubject.add(value);
  }

  /// Returns the current value of the state atom.
  S get value => _stateSubject.value;

  @override
  void dispose() {
    _subject.close();
    super.dispose();
  }
}
