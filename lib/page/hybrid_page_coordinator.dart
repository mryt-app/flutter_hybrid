import 'package:flutter/widgets.dart';
import 'package:flutter_hybrid/flutter_hybrid.dart';
import 'package:flutter_hybrid/messaging/native_messenger.dart';
import 'package:flutter_hybrid/messaging/native_page_event_handler.dart';
import 'package:flutter_hybrid/page/hybrid_page.dart';
import 'package:flutter_hybrid/page/hybrid_page_route.dart';
import 'package:flutter_hybrid/support/logger.dart';

class HybridPageCoordinator implements NativePageLifecycleEventHandler {
  final Map<String, PageBuilder> _pageBuilders = <String, PageBuilder>{};
  PageBuilder _defaultPageBuilder;

  HybridPageCoordinator() {
    FlutterHybrid.sharedInstance.nativePageLifecycleObserver.addEventHandler(this);
  }

  // Page builders

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

  // NativePageLifecycleEventHandler

  @override
  bool nativePageDidInit(String routeName, Map params, String pageId) {
    FlutterHybrid.sharedInstance.pageLifecycleObserverManager.
      notifyObservers(_createPageSettings(routeName, params, pageId), HybridPageLifecycle.init);
    return true;
  }

  @override
  bool nativePageWillAppear(String routeName, Map params, String pageId) {
    if (!FlutterHybrid.pageContainer.containsPage(pageId)) {
      FlutterHybrid.pageContainer.push(_createPageSettings(routeName, params, pageId));
      return true;
    }
    return false;
  }

  @override
  bool nativePageDidAppear(String routeName, Map params, String pageId) {
    HybridPageSettings pageSettings = _createPageSettings(routeName, params, pageId);
    FlutterHybrid.pageContainer.showHybridPage(pageSettings);
    FlutterHybrid.sharedInstance.pageLifecycleObserverManager.
      notifyObservers(pageSettings, HybridPageLifecycle.appear);
    
    return true;
  }

  @override
  bool nativePageWillDisappear(String routeName, Map params, String pageId) {
    return true;
  }

  @override
  bool nativePageDidDisappear(String routeName, Map params, String pageId) {
    FlutterHybrid.sharedInstance.pageLifecycleObserverManager.
      notifyObservers(_createPageSettings(routeName, params, pageId), HybridPageLifecycle.disappear);
    return true;
  }

  @override
  bool nativePageWillDealloc(String routeName, Map params, String pageId) {
    FlutterHybrid.sharedInstance.pageLifecycleObserverManager.
      notifyObservers(_createPageSettings(routeName, params, pageId), HybridPageLifecycle.destroy);
    FlutterHybrid.pageContainer.remove(pageId);
    return true;
  }

  // Public

  /// A hybrid page show phases:
  /// 1. Native page container created.
  /// 2. Move [FlutterView] to the new native page container
  /// 3. notify flutter navigate to new page
  /// The first native page may notify flutter before the flutter initialized,
  /// we fetch the first page info, and guarantee it visible.
  void showStartPageIfNeeded() async {
    final Map<String, dynamic> pageInfo = await FlutterHybrid.sharedInstance
      .nativeNavigationMessenger.fetchStartPageInfo();
    if (pageInfo == null || pageInfo.isEmpty) {
      return;
    }

    String routeName = pageInfo['routeName'];
    Map params = pageInfo['params'];
    String uniqueID = pageInfo['uniqueID'];
    if (routeName != null && uniqueID != null) {
      nativePageDidAppear(routeName, params, uniqueID);
    }
  }

  // Private

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

}