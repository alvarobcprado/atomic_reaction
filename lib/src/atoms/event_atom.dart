part of './atom.dart';

/// {@template event_atom}
/// An [EventAtom] is the smallest unit of event with type [E] in the
/// application.
/// It is a simple wrapper around a [PublishSubject] that allows
/// you to call the [EventAtom] and listen to the result.
/// {@endtemplate}
final class EventAtom<E> extends Atom<E> with TypeAtomListenerMixin<E> {
  /// {@macro event_atom}
  EventAtom() : super(PublishSubject<E>());

  /// Calls the event atom with the given value.
  ///
  /// This method emits the given event and notifies any subscribers.
  ///
  /// Example usage:
  /// ```dart
  /// EventAtom<String> atom = EventAtom<String>();
  /// atom('Hello, world!');
  /// ```
  void call(E value) {
    _subject.add(value);
  }
}

/// {@template event_void_atom}
/// An [EventVoidAtom] is the smallest unit of event without a value in the
/// application.
/// {@endtemplate}
final class EventVoidAtom extends EventAtom<void> {
  /// {@macro event_void_atom}
  EventVoidAtom();

  @override
  void call([void value]) {
    _subject.add(null);
  }
}
