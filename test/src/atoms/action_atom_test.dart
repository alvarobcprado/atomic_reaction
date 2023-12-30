import 'package:atomic_reaction/src/atoms/atom.dart';
import 'package:atomic_reaction/src/listener/listener_modifier.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

void main() {
  group('ActionAtom', () {
    late ActionAtom<int> actionAtom;

    setUp(() {
      actionAtom = ActionAtom<int>();
    });

    tearDown(() {
      actionAtom.dispose();
    });

    test('should notify subscribers', () {
      final values = <int>[];
      actionAtom.call(1);

      expect(actionAtom.stream, emitsInOrder(values));
    });

    test('should dispose the atom', () {
      final expected = [emitsDone];
      actionAtom.dispose();
      expect(actionAtom.isClosed, true);
      expectLater(actionAtom.stream, emitsInOrder(expected));
    });

    test('is broadcast atom', () {
      final expected = [1];
      expect(actionAtom.stream.isBroadcast, true);
      expectLater(actionAtom.stream, emitsInOrder(expected));
      expectLater(actionAtom.stream, emitsInOrder(expected));
      expectLater(actionAtom.stream, emitsInOrder(expected));

      actionAtom.call(1);
    });

    test('should not emit when the value is the same', () {
      final expected = [1];
      expectLater(actionAtom.stream, emitsInOrder(expected));
      expectLater(actionAtom.stream, emitsInOrder(expected));
      expectLater(actionAtom.stream, emitsInOrder(expected));

      actionAtom
        ..call(1)
        ..call(1)
        ..call(1);
    });

    test('throws StateError when update value after dispose', () {
      actionAtom.dispose();
      expect(() => actionAtom.call(1), throwsStateError);
    });
  });

  group('ActionVoidAtom', () {
    late ActionVoidAtom actionAtom;

    setUp(() {
      actionAtom = ActionVoidAtom();
    });

    tearDown(() {
      actionAtom.dispose();
    });

    test('should notify subscribers', () {
      final values = <int>[];
      actionAtom.call();

      expect(actionAtom.stream, emitsInOrder(values));
    });

    test('should dispose the atom', () {
      final expected = [emitsDone];
      actionAtom.dispose();
      expect(actionAtom.isClosed, true);
      expectLater(actionAtom.stream, emitsInOrder(expected));
    });

    test('is broadcast atom', () {
      final expected = <void>[];
      expect(actionAtom.stream.isBroadcast, true);
      expectLater(actionAtom.stream, emitsInOrder(expected));
      expectLater(actionAtom.stream, emitsInOrder(expected));
      expectLater(actionAtom.stream, emitsInOrder(expected));

      actionAtom.call();
    });

    test('throws StateError when update value after dispose', () {
      actionAtom.dispose();
      expect(() => actionAtom.call(), throwsStateError);
    });
  });

  group('ActionAtom listener', () {
    late ActionAtom<int> eventAtom;

    setUp(() {
      eventAtom = ActionAtom<int>();
    });

    tearDown(() {
      eventAtom.dispose();
    });

    test('should listen to changes when add listener', () async {
      final expected = [1, 2, 3];
      final actual = <int>[];

      eventAtom
        ..addListener(actual.add)
        ..call(1)
        ..call(2)
        ..call(3);

      await TestUtils.future;

      expect(actual, expected);
    });

    test('should not listen after remove listener', () async {
      final expected = [1];
      final actual = <int>[];

      eventAtom
        ..addListener(actual.add)
        ..call(1);

      await TestUtils.future;

      eventAtom
        ..removeListener(actual.add)
        ..call(2);

      await TestUtils.future;

      expect(actual, expected);
    });

    test('throws StateError when add listener after dispose', () async {
      eventAtom.dispose();
      expect(() => eventAtom.addListener((_) {}), throwsStateError);
    });

    test('do not throws error when remove listener after dispose', () async {
      eventAtom.dispose();
      expect(() => eventAtom.removeListener((_) {}), returnsNormally);
    });

    test('modifies the listener calls when use modifier', () async {
      final expected = [3];
      final actual = <int>[];

      eventAtom
        ..addListener(
          actual.add,
          modifier: ListenerModifiers.debounceTime(
            const Duration(milliseconds: 10),
          ),
        )
        ..call(1)
        ..call(2)
        ..call(3);

      await TestUtils.futureDelay(20);

      expect(actual, expected);
    });
  });
}
