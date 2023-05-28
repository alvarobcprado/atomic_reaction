typedef AtomCallback<T> = void Function(T value);
typedef AtomVoidCallback = void Function();
typedef AtomListenerModifier<T> = Stream<T> Function(Stream<T> listener);
