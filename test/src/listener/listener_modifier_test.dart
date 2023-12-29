import 'package:atomic_reaction/src/listener/listener_modifier.dart';
import 'package:atomic_reaction/src/utils/typedefs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';

class MockStream<T> extends Mock implements PublishSubject<T> {}

void main() {
  group('ListenerModifiers', () {
    late MockStream<int> events;
    late AtomListenerMapper<int> mapper;

    setUp(() {
      events = MockStream<int>();
      mapper = (value) => Stream.value((value as int) * 2);
      when(() => events.stream).thenAnswer((_) => const Stream.empty());
    });

    test('defaultModifier should call flatMap', () {
      final modifier = ListenerModifiers.defaultModifier<int>();
      modifier(events.stream, mapper);

      verify(() => events.stream.flatMap(mapper, maxConcurrent: null))
          .called(1);
    });

    test('flatMap should call flatMap with maxConcurrent', () {
      final modifier = ListenerModifiers.flatMap<int>(maxConcurrent: 2);
      modifier(events.stream, mapper);

      verify(() => events.stream.flatMap(mapper, maxConcurrent: 2)).called(1);
    });

    test('switchMap should call switchMap', () {
      final modifier = ListenerModifiers.switchMap<int>();
      modifier(events.stream, mapper);

      verify(() => events.stream.switchMap(mapper)).called(1);
    });

    test('exhaustMap should call exhaustMap', () {
      final modifier = ListenerModifiers.exhaustMap<int>();
      modifier(events.stream, mapper);

      verify(() => events.stream.exhaustMap(mapper)).called(1);
    });

    test('debounce should call debounce', () {
      final modifier = ListenerModifiers.debounce<int>();
      modifier(events.stream, mapper);

      verify(() => events.stream.debounce(mapper)).called(1);
    });

    test('debounceTime should call debounceTime and flatMap', () {
      const duration = Duration(seconds: 1);
      final modifier = ListenerModifiers.debounceTime<int>(duration);
      modifier(events.stream, mapper);

      verify(() => events.stream.debounceTime(duration).flatMap(mapper))
          .called(1);
    });

    test('throttle should call throttle', () {
      final modifier = ListenerModifiers.throttle<int>();
      modifier(events.stream, mapper);

      verify(() => events.stream.throttle(mapper)).called(1);
    });

    test('throttleTime should call throttleTime and flatMap', () {
      const duration = Duration(seconds: 1);
      final modifier = ListenerModifiers.throttleTime<int>(duration);
      modifier(events.stream, mapper);

      verify(() => events.stream.throttleTime(duration).flatMap(mapper))
          .called(1);
    });
  });
}
