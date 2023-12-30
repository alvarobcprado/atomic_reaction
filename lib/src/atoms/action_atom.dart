part of './atom.dart';

/// {@template action_atom}
/// An [ActionAtom] is the smallest unit of action with type [A] in the
/// application.
/// It is a simple wrapper around a [PublishSubject] that allows
/// you to call the [ActionAtom] and listen to the result.
/// {@endtemplate}
class ActionAtom<A> extends Atom<A> with TypeAtomListenerMixin<A> {
  /// {@macro action_atom}
  ActionAtom() : super(PublishSubject<A>());

  /// Calls the action atom with the given value.
  ///
  /// This method emits the given action and notifies any subscribers.
  ///
  /// Example usage:
  /// ```dart
  /// ActionAtom<String> atom = ActionAtom<String>();
  /// atom('Hello, world!');
  /// ```
  void call(A value) {
    _subject.add(value);
  }
}

/// {@template action_void_atom}
/// An [ActionVoidAtom] is the smallest unit of action without a value in the
/// application.
/// {@endtemplate}
final class ActionVoidAtom extends ActionAtom<void> {
  /// {@macro action_void_atom}
  ActionVoidAtom();

  @override
  void call([void value]) {
    _subject.add(null);
  }
}
