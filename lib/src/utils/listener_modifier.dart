import 'package:atomic_reaction/atomic_modifiers.dart';
import 'package:atomic_reaction/src/utils/typedefs.dart';

/// A set of functions used to modify the listener of an atom.
///
/// Has some default modifiers like `flatMap`, `switchMap`, `debounce`, etc.
///
/// If you want to create your own modifier, you can use the
/// [AtomListenerModifier] typedef. For example:
///
/// ```dart
/// AtomListenerModifier<T> myModifier<T>() =>
/// (events, mapper) => events.myOperator(mapper);
/// ```
abstract class ListenerModifiers {
  /// The default modifier used by atoms . It's the `flatMap` modifier.
  static AtomListenerModifier<T> defaultModifier<T>() => flatMap();

  /// {@nodoc}
  static AtomListenerModifier<T> flatMap<T>({int? maxConcurrent}) =>
      (events, mapper) => events.flatMap(mapper, maxConcurrent: maxConcurrent);

  /// {@nodoc}
  static AtomListenerModifier<T> switchMap<T>() =>
      (events, mapper) => events.switchMap(mapper);

  /// {@nodoc}
  static AtomListenerModifier<T> exhaustMap<T>() =>
      (events, mapper) => events.exhaustMap(mapper);

  /// {@nodoc}
  static AtomListenerModifier<T> debounce<T>() =>
      (events, mapper) => events.debounce(mapper);

  /// {@nodoc}
  static AtomListenerModifier<T> debounceTime<T>(Duration duration) =>
      (events, mapper) => events.debounceTime(duration).flatMap(mapper);

  /// {@nodoc}
  static AtomListenerModifier<T> throttle<T>() =>
      (events, mapper) => events.throttle(mapper);

  /// {@nodoc}
  static AtomListenerModifier<T> throttleTime<T>(Duration duration) =>
      (events, mapper) => events.throttleTime(duration).flatMap(mapper);
}
