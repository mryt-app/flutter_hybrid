import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hybrid/messaging/native_messenger_proxy.dart';
import 'package:flutter_hybrid/messaging/native_navigation_messenger.dart';
import 'package:flutter_hybrid/messaging/native_page_lifecycle_messenger.dart';
import 'package:flutter_hybrid/page/hybrid_page_container.dart';
import 'package:flutter_hybrid/page/hybrid_page_coordinator.dart';
import 'package:flutter_hybrid/page/hybrid_page_observer.dart';
import 'package:flutter_hybrid/page/hybrid_page_route.dart';
import 'package:flutter_hybrid/router/router.dart';

typedef Route PrePushRouteCallback(
    String uniqueID, String pageName, Map params, Route route);

typedef void PostPushRouteCallback(
    String uniqueID, String pageName, Map params, Route route, Future result);

class FlutterHybrid {
  static FlutterHybrid _sharedInstance = FlutterHybrid._internal();
  static FlutterHybrid get sharedInstance => _sharedInstance;

  final GlobalKey<HybridPageContainerState> pageContainerKey = 
    GlobalKey<HybridPageContainerState>();

  static HybridPageContainerState get pageContainer => 
    _sharedInstance.pageContainerKey.currentState;

  final HybridPageContainerOperationObserverManager _pageContainerOperationObserverManager =
    HybridPageContainerOperationObserverManager();
  HybridPageContainerOperationObserverManager get pageContainerOperationObserverManager => _pageContainerOperationObserverManager;

  final HybridPageLifecycleObserverManager _pageLifecycleObserverManager =
    HybridPageLifecycleObserverManager();
  HybridPageLifecycleObserverManager get pageLifecycleObserverManager => _pageLifecycleObserverManager;

  final HybridPageCoordinator _pageCoordinator = HybridPageCoordinator();
  HybridPageCoordinator get pageCoordinator => _pageCoordinator;

  final NativePageLifecycleMessenger _nativePageLifecycleObserver = NativePageLifecycleMessenger();
  NativePageLifecycleMessenger get nativePageLifecycleObserver => _nativePageLifecycleObserver;

  final NativeNavigationMessenger _nativeNavigationMessenger = NativeNavigationMessenger();
  NativeNavigationMessenger get nativeNavigationMessenger => _nativeNavigationMessenger;

  final NativeMessengerProxy _nativeMessengerProxy = NativeMessengerProxy();

  final Router _router = Router();
  Router get router => _router;

  FlutterHybrid._internal();

  void startRun() {
    _nativeMessengerProxy
      ..addMessenger(_nativePageLifecycleObserver)
      ..addMessenger(_nativeNavigationMessenger);

    _nativePageLifecycleObserver.addEventHandler(_pageCoordinator);

    _pageCoordinator.showStartPageIfNeeded();
  }

  void registerPageBuilders(Map<String, PageBuilder> builders) {
    _pageCoordinator.registerPageBuilders(builders);
  }

  static TransitionBuilder transitionBuilder(
      {TransitionBuilder builder,
      PrePushRouteCallback prePushRouteCallback,
      PostPushRouteCallback postPushRouteCallback}) {
    return (BuildContext context, Widget child) {
      assert(child is Navigator, 'child must be Navigator, what is wrong?');

      final HybridPageContainer pageContainer = HybridPageContainer(
        key: _sharedInstance.pageContainerKey,
        initialNavigator: child,
        prePushRouteCallback: prePushRouteCallback,
        postPushRouteCallback: postPushRouteCallback,
      );
      if (builder != null) {
        return builder(context, pageContainer);
      } else {
        return pageContainer;
      }
    };
  }
}
