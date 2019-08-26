import 'dart:ui';

class ObserversHolder {
  final Map<String, Set<dynamic>> _observers = Map<String, Set<dynamic>>();

  VoidCallback addObserver<T>(T observer) {
    final Set<T> observers = _observers[T.toString()] ?? Set<T>();

    observers.add(observer);
    _observers[T.toString()] = observers;

    return () => observers.remove(observer);
  }

  void removeObserver<T>(T observer) =>
      _observers[T.toString()]?.remove(observer);

  void cleanObservers<T>(T observer) => _observers[T.toString()]?.clear();

  Set<T> observersOf<T>() => _observers[T.toString()] ?? Set<T>();
}
