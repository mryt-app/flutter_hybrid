import 'package:flutter_hybrid/flutter_hybrid.dart';

class Router {
  Future<void> openPage(String routeName, {Map params, bool animated = true}) {
    return FlutterHybrid.sharedInstance
    .nativeNavigationMessenger.openPage(routeName, params, animated);
  }

  Future<void> closePage(String pageId, {Map params, bool animated = true}) {
    return FlutterHybrid.sharedInstance.nativeNavigationMessenger.closePage(pageId, params, animated);
  }
}