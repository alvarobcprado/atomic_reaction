import 'package:atomic_reaction/src/atoms/atom.dart';
import 'package:atomic_reaction/src/listener/listener_modifier.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

void main() {
  group('StateAtom', () {
    late StateAtom<int> stateAtom;

    setUp(() {
      stateAtom = StateAtom<int>(0);
    });

    tearDown(() {
      stateAtom.dispose();
    });

    test('should initialize with the provided value', () {
      expect(stateAtom.value, 0);
    });

    test('should update the value and notify subscribers', () {
      final values = <int>[];
      stateAtom.value = 1;

      expect(stateAtom.value, 1);
      expect(stateAtom.stream, emitsInOrder(values));
    });

    test('should get the current value', () {
      expect(stateAtom.value, 0);
      stateAtom.value = 2;
      expect(stateAtom.value, 2);
    });

    test('should dispose the atom', () {
      final expected = [emitsDone];
      stateAtom.dispose();
      expect(stateAtom.isClosed, true);
      expectLater(stateAtom.stream, emitsInOrder(expected));
    });

    test('is broadcast atom', () {
      final expected = [1];
      expect(stateAtom.stream.isBroadcast, true);
      expectLater(stateAtom.stream, emitsInOrder(expected));
      expectLater(stateAtom.stream, emitsInOrder(expected));
      expectLater(stateAtom.stream, emitsInOrder(expected));

      stateAtom.value = 1;
    });

    test('should not emit when the value is the same', () {
      final expected = [1];
      expectLater(stateAtom.stream, emitsInOrder(expected));
      expectLater(stateAtom.stream, emitsInOrder(expected));
      expectLater(stateAtom.stream, emitsInOrder(expected));

      stateAtom
        ..value = 1
        ..value = 1
        ..value = 1;
    });

    test('throws StateError when update value after dispose', () {
      stateAtom.dispose();
      expect(() => stateAtom.value = 1, throwsStateError);
    });
  });

  group('StateAtom listener', () {
    late StateAtom<int> stateAtom;

    setUp(() {
      stateAtom = StateAtom<int>(0);
    });

    tearDown(() {
      stateAtom.dispose();
    });

    test('should listen to changes when add listener', () async {
      final expected = [1, 2, 3];
      final actual = <int>[];

      stateAtom
        ..addListener(actual.add)
        ..value = 1
        ..value = 2
        ..value = 3;

      await TestUtils.future;

      expect(actual, expected);
    });

    test('should not listen after remove listener', () async {
      final expected = [1];
      final actual = <int>[];

      stateAtom
        ..addListener(actual.add)
        ..value = 1;

      await TestUtils.future;

      stateAtom
        ..removeListener(actual.add)
        ..value = 2;

      await TestUtils.future;

      expect(actual, expected);
    });

    test('throws StateError when add listener after dispose', () {
      stateAtom.dispose();
      expect(() => stateAtom.addListener((_) {}), throwsStateError);
    });

    test('do not throws error when remove listener after dispose', () async {
      stateAtom.dispose();
      expect(() => stateAtom.removeListener((_) {}), returnsNormally);
    });

    test('modifies the listener calls when use modifier', () async {
      final expected = [3];
      final actual = <int>[];

      stateAtom
        ..addListener(
          actual.add,
          modifier: ListenerModifiers.debounceTime(
            const Duration(milliseconds: 10),
          ),
        )
        ..value = 1
        ..value = 2
        ..value = 3;

      await TestUtils.futureDelay(20);

      expect(actual, expected);
    });
  });
}
