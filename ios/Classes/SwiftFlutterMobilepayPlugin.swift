import Flutter
import UIKit

public class SwiftFlutterMobilepayPlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_mobilepay", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterMobilepayPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getPlatformVersion") {
      result("iOS " + UIDevice.current.systemVersion)
    } else if (call.method == "isMobilePayInstalled") {
        let installed = MobilePayManager.sharedInstance().isMobilePayInstalled(MobilePayCountry.finland)
        result(installed)
    } else if (call.method == "setup") {
//        MobilePayManager.sharedInstance().setup(withMerchantId: "APPFI0000000000", merchantUrlScheme: "arnolds", country: MobilePayCountry.finland)
    } else if (call.method == "payment") {

    }
  }
}
