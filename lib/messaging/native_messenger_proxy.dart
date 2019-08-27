import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hybrid/messaging/native_messenger.dart';

class NativeMessengerProxy {
  final MethodChannel _channel = MethodChannel('flutter_hybrid');
  final Set<NativeMessenger> _messengers = Set<NativeMessenger>();

  NativeMessengerProxy() {
    _channel.setMethodCallHandler(handleMethodCall);
  }

  Future<void> handleMethodCall(MethodCall call) async {
    String method = call.method;
    List<String> components = method.split('.');
    if (components.length != 2) {
      throw 'method name is invalid: $method';
    }
    String messengerName = components.first;
    NativeMessenger messenger = _messengers.firstWhere(
      (aMessenger) => aMessenger.name == messengerName
    );
    if (messenger != null) {
      return messenger.handleMethodCall(call);
    }
  }

  VoidCallback addMessenger(NativeMessenger messenger) {
    _messengers.add(messenger);
    return () => _messengers.remove(messenger);
  }

  void removeMessenger(NativeMessenger messenger) {
    _messengers.remove(messenger);
  }
  
}