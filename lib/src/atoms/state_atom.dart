part of './atom.dart';

/// An [StateAtom] is the smallest unit of state in the application.
/// It is a simple wrapper around a [BehaviorSubject] that allows
/// you to get and set the value of the [StateAtom] and listen to changes.
final class StateAtom<T> extends Atom<T> with TypeAtomListenerMixin<T> {
  StateAtom(T value) : super(BehaviorSubject<T>.seeded(value));

  BehaviorSubject<T> get _stateSubject => _subject as BehaviorSubject<T>;

  set value(T value) {
    _stateSubject.add(value);
  }

  T get value => _stateSubject.value;

  T? get valueOrNull => _stateSubject.valueOrNull;

  bool get hasValue => _stateSubject.hasValue;

  @override
  void dispose() {
    _subject.close();
    super.dispose();
  }
}
