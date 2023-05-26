import 'package:atomic_reaction/src/atoms/atom.dart';
import 'package:rxdart/rxdart.dart';

/// An [ActionAtom] is the smallest unit of action in the application.
/// It is a simple wrapper around a [PublishSubject] that allows
/// you to call the [ActionAtom] and listen to the result.
final class ActionAtom<T> extends Atom<T> {
  ActionAtom() : _subject = PublishSubject<T>();

  final PublishSubject<T> _subject;

  @override
  Stream<T> get stream => _subject.stream;

  @override
  void call(T value) {
    _subject.add(value);
  }
}

final class VoidActionAtom extends ActionAtom<void> {
  @override
  void call([value]) {
    _subject.add(null);
  }
}
