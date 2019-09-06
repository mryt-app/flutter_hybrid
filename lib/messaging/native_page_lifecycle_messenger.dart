import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hybrid/messaging/native_messenger.dart';
import 'package:flutter_hybrid/messaging/native_page_event_handler.dart';

class NativePageLifecycleMessenger implements NativeMessenger {
  final Set<NativePageLifecycleEventHandler> _eventHandlers =
      Set<NativePageLifecycleEventHandler>();

  VoidCallback addEventHandler(NativePageLifecycleEventHandler eventHandler) {
    _eventHandlers.add(eventHandler);
    return () => _eventHandlers.remove(eventHandler);
  }

  void removeEventHandler(NativePageLifecycleEventHandler eventHandler) {
    _eventHandlers.remove(eventHandler);
  }

  @override
  Future<void> handleMethodCall(String method, dynamic arguments) async {
    String routeName = arguments['routeName'];
    Map params = arguments['params'];
    String pageId = arguments['uniqueID'];
    for (NativePageLifecycleEventHandler eventHandler in _eventHandlers) {
      switch (method) {
        case 'nativePageDidInit':
          eventHandler.nativePageDidInit(routeName, params, pageId);
          break;
        case 'nativePageWillAppear':
          eventHandler.nativePageWillAppear(routeName, params, pageId);
          break;
        case 'nativePageDidAppear':
          eventHandler.nativePageDidAppear(routeName, params, pageId);
          break;
        case 'nativePageWillDisappear':
          eventHandler.nativePageWillDisappear(routeName, params, pageId);
          break;
        case 'nativePageDidDisappear':
          eventHandler.nativePageDidDisappear(routeName, params, pageId);
          break;
        case 'nativePageWillDealloc':
          eventHandler.nativePageWillDealloc(routeName, params, pageId);
          break;
        default:
      }
    }
  }

  @override
  String get name => 'NativePageLifecycle';

  @override
  void setMethodChannel(MethodChannel channel) {
  }
}
