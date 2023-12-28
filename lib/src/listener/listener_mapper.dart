import 'dart:async';

import 'package:atomic_reaction/src/utils/typedefs.dart';

/// A set of functions used to map the listener of an atom.
abstract class ListenerMappers {
  /// {@nodoc}
  static AtomListenerMapper<T> defaultMapper<T>(
    FutureOr<void> Function(T data) callback,
  ) {
    Stream<T> mapper(dynamic event) {
      final controller = StreamController<T>.broadcast(sync: true);

      Future<void> onEvent() async {
        try {
          await callback(event as T);
        } catch (_) {
          rethrow;
        } finally {
          if (!controller.isClosed) await controller.close();
        }
      }

      onEvent();
      return controller.stream;
    }

    return mapper;
  }
}
