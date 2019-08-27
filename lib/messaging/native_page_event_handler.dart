abstract class NativePageLifecycleEventHandler {
  bool nativePageDidInit(String routeName, Map params, String pageId);
  bool nativePageWillAppear(String routeName, Map params, String pageId);
  bool nativePageDidAppear(String routeName, Map params, String pageId);
  bool nativePageWillDisappear(String routeName, Map params, String pageId);
  bool nativePageDidDisappear(String routeName, Map params, String pageId);
  bool nativePageWillDealloc(String routeName, Map params, String pageId);
}