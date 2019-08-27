import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hybrid/messaging/native_messenger.dart';
import 'package:flutter_hybrid/messaging/native_page_event_handler.dart';

class NativePageLifecycleObserver implements NativeMessenger {
  MethodChannel _channel;
  final Set<NativePageLifecycleEventHandler> _eventHandlers =
      Set<NativePageLifecycleEventHandler>();

  NativePageLifecycleObserver() {
    _channel.setMethodCallHandler(handleMethodCall);
  }

  VoidCallback addEventHandler(NativePageLifecycleEventHandler eventHandler) {
    _eventHandlers.add(eventHandler);
    return () => _eventHandlers.remove(eventHandler);
  }

  void removeEventHandler(NativePageLifecycleEventHandler eventHandler) {
    _eventHandlers.remove(eventHandler);
  }

  Future<void> handleMethodCall(MethodCall call) async {
    String routeName = call.arguments['routeName'];
    Map params = call.arguments['params'];
    String pageId = call.arguments['uniqueID'];
    for (NativePageLifecycleEventHandler eventHandler in _eventHandlers) {
      switch (call.method) {
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
    _channel = channel;
  }
}
