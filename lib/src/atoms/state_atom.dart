import 'package:atomic_reaction/src/atoms/atom.dart';
import 'package:rxdart/rxdart.dart';

/// An [StateAtom] is the smallest unit of state in the application.
/// It is a simple wrapper around a [BehaviorSubject] that allows
/// you to get and set the value of the [StateAtom] and listen to changes.
final class StateAtom<T> extends Atom<T> {
  StateAtom(T value) : _subject = BehaviorSubject<T>.seeded(value);

  final BehaviorSubject<T> _subject;

  @override
  Stream<T> get stream => _subject.stream;

  @override
  void call(T value) {
    _subject.add(value);
  }

  T get value => _subject.value;

  @override
  void dispose() {
    _subject.close();
    super.dispose();
  }
}
