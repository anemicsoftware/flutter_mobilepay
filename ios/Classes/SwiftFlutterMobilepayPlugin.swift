import Flutter
import UIKit

public class SwiftFlutterMobilepayPlugin: NSObject, FlutterPlugin {
    public static func getResult() -> FlutterResult? {
        return result
    }
    private static var result: FlutterResult?
    
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
        guard let args = call.arguments else {
            return
        }
        if let myArgs = args as? [String: Any],
           let merchantId = myArgs["merchantId"] as? String,
           let scheme = myArgs["scheme"] as? String {
            MobilePayManager.sharedInstance().setup(withMerchantId: merchantId, merchantUrlScheme: scheme, country: MobilePayCountry.finland)
        result(true)
        } else {
            result(FlutterError(code: "-1", message: "Incorrect arguments", details: nil))
        }
    } else if (call.method == "payment") {
        guard let args = call.arguments else {
            return
        }
        if let myArgs = args as? [String: Any],
           let orderId = myArgs["orderId"] as? String,
           let price = myArgs["price"] as? Int {
            let p = Decimal( price) / Decimal(100)
            let ns = NSDecimalNumber(decimal: p)
            SwiftFlutterMobilepayPlugin.result = result
            MobilePayManager.sharedInstance().beginMobilePayment(withOrderId: orderId, productPrice: ns, error: { error in
                //print(orderId)
            })
            result("OK")
        } else {
            result(FlutterError(code: "-1", message: "Incorrect arguments", details: nil))
        }

    }
  }
}
