import 'package:flutter/widgets.dart';
import 'package:flutter_hybrid/flutter_hybrid.dart';
import 'package:flutter_hybrid/page/hybrid_page_container.dart';
import 'package:flutter_hybrid/page/hybrid_page_observer.dart';
import 'package:flutter_hybrid/page/hybrid_page_route.dart';
import 'package:flutter_hybrid/support/logger.dart';

enum HybridPageLifecycle {
  init,
  appear,
  disappear,
  destroy,
  background,
  foreground,
}

class HybridPageSettings {
  final String uniqueID;
  final String routeName;
  final Map params;
  final WidgetBuilder builder;

  const HybridPageSettings(
      {this.uniqueID, this.routeName, this.params, this.builder});

  HybridPageSettings.defaultSettings(
      {this.uniqueID = 'default',
      this.routeName = 'default',
      this.params,
      this.builder});

  String toString() {
    return 'HybridPageSettings(pageId: $uniqueID, routeName: $routeName)';
  }
}

class HybridPage extends Navigator {
  final HybridPageSettings settings;

  const HybridPage(
      {GlobalKey<HybridPageState> key,
      HybridPageSettings settings,
      String initialRoute,
      RouteFactory onGenerateRoute,
      RouteFactory onUnknownRoute,
      List<NavigatorObserver> observers})
      : settings = settings,
        super(
            key: key,
            initialRoute: initialRoute,
            onGenerateRoute: onGenerateRoute,
            onUnknownRoute: onUnknownRoute,
            observers: observers);

  factory HybridPage.copy(Navigator navigator, HybridPageSettings settings) =>
      HybridPage(
        key: GlobalKey<HybridPageState>(),
        settings: settings,
        initialRoute: navigator.initialRoute,
        onGenerateRoute: navigator.onGenerateRoute,
        onUnknownRoute: navigator.onUnknownRoute,
        observers: navigator.observers,
      );

  factory HybridPage.obtain(Navigator navigator, HybridPageSettings settings) =>
      HybridPage(
          key: GlobalKey<HybridPageState>(),
          settings: settings,
          onGenerateRoute: (RouteSettings routeSettings) {
            if (routeSettings.name == '/') {
              return HybridPageRoute<dynamic>(
                  routeName: settings.routeName,
                  params: settings.params,
                  uniqueID: settings.uniqueID,
                  animated: false,
                  settings: routeSettings,
                  builder: settings.builder);
            } else {
              return navigator.onGenerateRoute(routeSettings);
            }
          },
          observers: <NavigatorObserver>[
            HybridPageNavigatorObserver.bindPageContainer()
          ],
          onUnknownRoute: navigator.onUnknownRoute);

  @override
  HybridPageState createState() => HybridPageState();

  @override
  StatefulElement createElement() => _HybridPageElement(this);

  static HybridPageState tryOf(BuildContext context) {
    final HybridPageState pageState =
        context.ancestorStateOfType(const TypeMatcher<HybridPageState>());
    return pageState;
  }

  static HybridPageState of(BuildContext context) {
    final HybridPageState pageState =
        context.ancestorStateOfType(const TypeMatcher<HybridPageState>());
    assert(pageState != null, 'Not in flutter hybrid.');
    return pageState;
  }

  String desc() =>
      '{routeName=${settings.routeName}, uniqueID=${settings.uniqueID}}';
}

class HybridPageState extends NavigatorState {
  final Set<VoidCallback> _backPressedListeners = Set<VoidCallback>();

  final Set<HybridPageResultObserver> _pageResultObservers =
      Set<HybridPageResultObserver>();

  String get uniqueID => widget.settings.uniqueID;

  String get routeName => widget.settings.routeName;

  Map get params => widget.settings.params;

  HybridPageSettings get settings => widget.settings;

  bool get onstage => HybridPageContainer.of(context).onstagePage == this;

  bool get maybeOnstageNext =>
      HybridPageContainer.of(context).maybeOnstageNextPage == this;

  @override
  HybridPage get widget => super.widget as HybridPage;

  HybridPageNavigatorObserver findHybridPageNavigatorObserver(
      Navigator navigator) {
    for (NavigatorObserver observer in navigator.observers) {
      if (observer is HybridPageNavigatorObserver) {
        return observer;
      }
    }

    return null;
  }

  @override
  void didUpdateWidget(Navigator oldWidget) {
    super.didUpdateWidget(oldWidget);
    findHybridPageNavigatorObserver(oldWidget)?.removeHybridPageObserver(
        HybridPageContainer.of(this.context).hybridPageObserverProxy);
  }

  @override
  void dispose() {
    findHybridPageNavigatorObserver(widget)?.removeHybridPageObserver(
        FlutterHybrid.pageContainer.hybridPageObserverProxy);
    super.dispose();
  }

  void onBackButtonPressed() {
    Logger.debug('onBackPressed');
    if (_backPressedListeners.isEmpty) {
      pop();
    } else {
      for (VoidCallback callback in _backPressedListeners) {
        callback();
      }
    }
  }

  void onPageResult(Map<dynamic, dynamic> data) {
    Logger.debug('onPageResult ${data.toString()}');

    final int requestCode = data['requestCode'];
    final int responseCode = data['responseCode'];
    final Map result = data['result'];

    for (HybridPageResultObserver observer in _pageResultObservers) {
      observer(requestCode, responseCode, result);
    }
  }

  @override
  bool pop<T extends Object>([T result]) {
    if (canPop()) {
      return super.pop(result);
    } else {
      FlutterHybrid.sharedInstance.router.closePage(uniqueID);
      return false;
    }
  }

  @override
  Future<T> push<T extends Object>(Route<T> route) {
    Route<T> newRoute;
    if (FlutterHybrid.pageContainer.prePushRouteCallback != null) {
      newRoute = FlutterHybrid.pageContainer
        .prePushRouteCallback(uniqueID, routeName, params, route);
    }

    Future<T> result = super.push<T>(newRoute ?? route);

    if (FlutterHybrid.pageContainer.postPushRouteCallback != null) {
      FlutterHybrid.pageContainer
        .postPushRouteCallback(uniqueID, routeName, params, newRoute ?? route, result);
    }

    return result;
  }

  VoidCallback addBackPressedListener(VoidCallback listener) {
    _backPressedListeners.add(listener);

    return () => _backPressedListeners.remove(listener);
  }

  VoidCallback addPageResultObserver(HybridPageResultObserver observer) {
    _pageResultObservers.add(observer);

    return () => _pageResultObservers.remove(observer);
  }

  VoidCallback addLifecycleObserver(HybridPageLifecycleObserver observer) {
    return FlutterHybrid.sharedInstance.pageLifecycleObserverManager.addObserver(
      (HybridPageSettings pageSettings, HybridPageLifecycle lifecycle) {
        if (pageSettings.uniqueID == uniqueID) {
          observer(settings, lifecycle);
        }
    });
  }
}

class _HybridPageElement extends StatefulElement {
  _HybridPageElement(StatefulWidget widget) : super(widget);
}
