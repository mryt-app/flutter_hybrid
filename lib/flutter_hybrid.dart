import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hybrid/page/hybrid_page_container.dart';
import 'package:flutter_hybrid/page/hybrid_page_observer.dart';
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

  final Router _router = Router();
  Router get router => _router;

  FlutterHybrid._internal();

  static const MethodChannel _channel =
      const MethodChannel('flutter_hybrid');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
