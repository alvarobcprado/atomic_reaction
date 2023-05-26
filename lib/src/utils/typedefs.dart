typedef AtomCallback<T> = void Function(T value);
typedef AtomListenerModifier<T> = Stream<T> Function(Stream<T> listener);
