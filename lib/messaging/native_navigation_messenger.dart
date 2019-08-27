import 'package:flutter/services.dart';
import 'package:flutter_hybrid/messaging/native_messenger.dart';

class NativeNavigationMessenger implements NativeMessenger {
  MethodChannel _channel;

  // NativeMessenger

  @override
  Future<void> handleMethodCall(MethodCall call) {
    // TODO: implement handleMethodCall
    return null;
  }

  @override
  String get name => 'NativeNavigation';

  @override
  void setMethodChannel(MethodChannel channel) {
    _channel = channel;
  }

  // Public

  Future<void> notifyFlutterCanPop(bool canPop) async {
    try {
      await _invokeMethod('flutterCanPopChanged', { 'canPop': canPop });
    } on PlatformException catch (e) {
      throw 'Unable to call native method:canPop, error: $e';
    }
  }

  Future<Map<String, dynamic>> fetchStartPageInfo() async {
    try {
      Map<String, dynamic> pageInfo = await _invokeMethod('fetchStartPageInfo', null);
      return pageInfo;
    } on PlatformException catch (e) {
      throw 'Unable to call native method:fetchStartPageInfo, error: $e';
    }
  }

  Future<dynamic> _invokeMethod(String method, dynamic params) {
    String methodName = this.name + '.' + method;
    return _channel.invokeMethod(methodName, params);
  }
  
}