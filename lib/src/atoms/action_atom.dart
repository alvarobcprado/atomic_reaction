part of './atom.dart';

/// An [ActionAtom] is the smallest unit of action in the application.
/// It is a simple wrapper around a [PublishSubject] that allows
/// you to call the [ActionAtom] and listen to the result.
final class ActionAtom<T> extends Atom<T> with TypeAtomListenerMixin<T> {
  ActionAtom() : super(PublishSubject<T>());

  void call(T value) {
    _subject.add(value);
  }
}

final class VoidActionAtom extends Atom<void> with VoidAtomListenerMixin {
  VoidActionAtom() : super(PublishSubject<void>());

  void call([value]) {
    _subject.add(null);
  }
}
