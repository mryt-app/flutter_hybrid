import 'package:flutter/widgets.dart';
import 'package:flutter_hybrid/flutter_hybrid.dart';
import 'package:flutter_hybrid/page/hybrid_page.dart';
import 'package:flutter_hybrid/page/hybrid_page_container.dart';
import 'package:flutter_hybrid/support/logger.dart';

typedef void HybridPageLifecycleObserver(
    HybridPageSettings pageSettings, HybridPageLifecycle lifecycle);

typedef void HybridPageResultObserver(
    int requestCode, int responseCode, Map<dynamic, dynamic> result);

typedef PageContainerOperationObserver = void Function(
    HybridPageSettings settings, HybridPageContainerOperation operation);

class HybridPageObserver {
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {}

  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {}

  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {}

  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {}
}

class HybridPageObserverProxy extends HybridPageObserver {
  final Set<HybridPageObserver> _observers = Set<HybridPageObserver>();

  VoidCallback addObserver(HybridPageObserver observer) {
    _observers.add(observer);
    return () => _observers.remove(observer);
  }

  void removeObserver(HybridPageObserver observer) {
    _observers.remove(observer);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    Logger.debug('Hybrid page didPush');
    for (HybridPageObserver observer in _observers) {
      observer.didPush(route, previousRoute);
    }
  }

  @override
  void didPop(Route route, Route previousRoute) {
    Logger.debug('Hybrid page didPop');
    for (HybridPageObserver observer in _observers) {
      observer.didPop(route, previousRoute);
    }
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    Logger.debug('Hybrid page didRemove');
    for (HybridPageObserver observer in _observers) {
      observer.didRemove(route, previousRoute);
    }
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    Logger.debug('Hybrid page didReplace');
    for (HybridPageObserver observer in _observers) {
      observer.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    }
  }
}

class HybridPageNavigatorObserver extends NavigatorObserver {
  HybridPageObserver observer;

  final Set<HybridPageObserver> _boostObservers =
      Set<HybridPageObserver>();

  HybridPageNavigatorObserver();

  factory HybridPageNavigatorObserver.bindPageContainer() =>
      HybridPageNavigatorObserver()
        ..addHybridPageObserver(
            FlutterHybrid.pageContainer.hybridPageObserverProxy);

  VoidCallback addHybridPageObserver(HybridPageObserver observer) {
    _boostObservers.add(observer);

    return () => _boostObservers.remove(observer);
  }

  void removeHybridPageObserver(HybridPageObserver observer) {
    _boostObservers.remove(observer);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    for (HybridPageObserver observer in _boostObservers) {
      observer.didPush(route, previousRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    for (HybridPageObserver observer in _boostObservers) {
      observer.didPop(route, previousRoute);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    for (HybridPageObserver observer in _boostObservers) {
      observer.didRemove(route, previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    for (HybridPageObserver observer in _boostObservers) {
      observer.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    }
  }
}

class HybridPageCanPopObserver extends HybridPageObserver {
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);

    _notifyCanPopToNative(route);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);

    _notifyCanPopToNative(route);
  }

  _notifyCanPopToNative(Route route){
    if(route.navigator == null){
       return;
    }
    bool canPop = route.navigator.canPop();
    FlutterHybrid.sharedInstance.nativeNavigationMessenger.notifyFlutterCanPop(canPop);
  }
}

class ObserverManager<T> {
  final Set<T> _observers = Set<T>();
  Set<T> get observers => _observers;

  VoidCallback addObserver(T observer) {
    _observers.add(observer);
    return () => _observers.remove(observer);
  }

  removeObserver(T observer) {
    _observers.remove(observer);
  }

  clearObservers() {
    _observers.clear();
  }
}

class HybridPageContainerOperationObserverManager extends ObserverManager<PageContainerOperationObserver> {
  void notifyObservers(HybridPageSettings settings, HybridPageContainerOperation operation) {
    for (PageContainerOperationObserver observer in this.observers) {
      observer(settings, operation);
    }
    Logger.debug('Page container operation with setttings: $settings, operation: $operation');
  }
}

class HybridPageLifecycleObserverManager extends ObserverManager<HybridPageLifecycleObserver> {
  void notifyObservers(HybridPageSettings pageSettings, HybridPageLifecycle lifecycle) {
    for (HybridPageLifecycleObserver observer in this.observers) {
      observer(pageSettings, lifecycle);
    }
    Logger.debug('Page lifecycle changed: $lifecycle, settings: $pageSettings');
  }
}
