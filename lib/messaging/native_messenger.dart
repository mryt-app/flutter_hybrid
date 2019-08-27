import 'package:flutter/services.dart';

abstract class NativeMessenger {
  String get name;
  void setMethodChannel(MethodChannel channel);
  Future<void> handleMethodCall(MethodCall call);
}