import 'package:flutter/widgets.dart';
import 'package:flutter_hybrid/flutter_hybrid.dart';
import 'package:flutter_hybrid/messaging/native_page_event_handler.dart';
import 'package:flutter_hybrid/page/hybrid_page.dart';
import 'package:flutter_hybrid/page/hybrid_page_route.dart';
import 'package:flutter_hybrid/support/logger.dart';

class HybridPageCoordinator implements NativePageEventHandler {
  static final HybridPageCoordinator sharedInstance = HybridPageCoordinator._internal();

  final Map<String, PageBuilder> _pageBuilders = <String, PageBuilder>{};
  PageBuilder _defaultPageBuilder;

  HybridPageCoordinator._internal() {
    // TODO: Listen event
  }

  HybridPageSettings _createPageSettings(
      String routeName, Map params, String pageId) {
    return HybridPageSettings(
      uniqueID: pageId,
      routeName: routeName,
      params: params,
      builder: (BuildContext context) {
        Widget page;
        if (_pageBuilders[routeName] != null) {
          page = _pageBuilders[routeName](routeName, params, pageId);
        } else {
          assert(_defaultPageBuilder != null);
          page = _defaultPageBuilder(routeName, params, pageId);
        }
        assert(page != null);
        Logger.debug('build widget:$page for page:$routeName($pageId)');

        return page;
      }
    );
  }

  void registerDefaultPageBuilder(PageBuilder pageBuilder) {
    _defaultPageBuilder = pageBuilder;
  }

  void registerPageBuilder(String routeName, PageBuilder pageBuilder) {
    assert(routeName != null);
    assert(pageBuilder != null);
    _pageBuilders[routeName] = pageBuilder;
  }

  void registerPageBuilders(Map<String, PageBuilder> builders) {
    assert(builders != null);
    if (builders.isNotEmpty) {
      _pageBuilders.addAll(builders);
    }
  }

  @override
  bool nativePageDidInit(String route, Map params, String pageId) {
    FlutterHybrid.sharedInstance.pageLifecycleObserverManager.
      notifyObservers(_createPageSettings(route, params, pageId), HybridPageLifecycle.init);
    return true;
  }

  @override
  bool nativePageWillAppear(String route, Map params, String pageId) {
    if (!FlutterHybrid.pageContainer.containsPage(pageId)) {
      FlutterHybrid.pageContainer.push(_createPageSettings(route, params, pageId));
      return true;
    }
    return false;
  }

  @override
  bool nativePageDidAppear(String route, Map params, String pageId) {
    HybridPageSettings pageSettings = _createPageSettings(route, params, pageId);
    FlutterHybrid.pageContainer.showHybridPage(pageSettings);
    FlutterHybrid.sharedInstance.pageLifecycleObserverManager.
      notifyObservers(pageSettings, HybridPageLifecycle.appear);
    
    return true;
  }

  @override
  bool nativePageWillDisappear(String route, Map params, String pageId) {
    return true;
  }

  @override
  bool nativePageDidDisappear(String route, Map params, String pageId) {
    FlutterHybrid.sharedInstance.pageLifecycleObserverManager.
      notifyObservers(_createPageSettings(route, params, pageId), HybridPageLifecycle.disappear);
    return true;
  }

  @override
  bool nativePageWillDealloc(String route, Map params, String pageId) {
    FlutterHybrid.sharedInstance.pageLifecycleObserverManager.
      notifyObservers(_createPageSettings(route, params, pageId), HybridPageLifecycle.destroy);
    FlutterHybrid.pageContainer.remove(pageId);
    return true;
  }

}