import 'package:atomic_reaction/src/atoms/atom.dart';
import 'package:atomic_reaction/src/listener/listener_modifier.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

void main() {
  group('EventAtom', () {
    late EventAtom<int> eventAtom;

    setUp(() {
      eventAtom = EventAtom<int>();
    });

    tearDown(() {
      eventAtom.dispose();
    });

    test('should notify subscribers', () {
      final values = <int>[];
      eventAtom.call(1);

      expect(eventAtom.stream, emitsInOrder(values));
    });

    test('should dispose the atom', () {
      final expected = [emitsDone];
      eventAtom.dispose();
      expect(eventAtom.isClosed, true);
      expectLater(eventAtom.stream, emitsInOrder(expected));
    });

    test('is broadcast atom', () {
      final expected = [1];
      expect(eventAtom.stream.isBroadcast, true);
      expectLater(eventAtom.stream, emitsInOrder(expected));
      expectLater(eventAtom.stream, emitsInOrder(expected));
      expectLater(eventAtom.stream, emitsInOrder(expected));

      eventAtom.call(1);
    });

    test('should not emit when the value is the same', () {
      final expected = [1];
      expectLater(eventAtom.stream, emitsInOrder(expected));
      expectLater(eventAtom.stream, emitsInOrder(expected));
      expectLater(eventAtom.stream, emitsInOrder(expected));

      eventAtom
        ..call(1)
        ..call(1)
        ..call(1);
    });

    test('throws StateError when update value after dispose', () {
      eventAtom.dispose();
      expect(() => eventAtom.call(1), throwsStateError);
    });
  });

  group('EventAtom listener', () {
    late EventAtom<int> eventAtom;

    setUp(() {
      eventAtom = EventAtom<int>();
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
