abstract class NativePageEventHandler {
  bool nativePageDidInit(String route, Map params, String pageId);
  bool nativePageWillAppear(String route, Map params, String pageId);
  bool nativePageDidAppear(String route, Map params, String pageId);
  bool nativePageWillDisappear(String route, Map params, String pageId);
  bool nativePageDidDisappear(String route, Map params, String pageId);
  bool nativePageWillDealloc(String route, Map params, String pageId);
}