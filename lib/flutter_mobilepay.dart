
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterMobilepay {
  static const MethodChannel _channel =
      const MethodChannel('flutter_mobilepay');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> setup(String merchantId) async {
    final bool version = await _channel.invokeMethod('setup', <String, dynamic>{'merchantId': merchantId});
    return version;
  }

  static Future<bool> get isMobilePayInstalled async {
    final bool version = await _channel.invokeMethod('isMobilePayInstalled');
    return version;
  }

  static Future<String> payment(String orderId, int price) async {
    final String result = await _channel.invokeMethod('payment', <String, dynamic>{'orderId': orderId, 'price': price});
    return result;
  }
}
