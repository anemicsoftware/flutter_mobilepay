import UIKit
import Flutter
import flutter_mobilepay

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        handleMobilePayPaymentWithUrl(url: url)
        return true
    }

    override func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        handleMobilePayPaymentWithUrl(url: url)
        return true
    }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        handleMobilePayPaymentWithUrl(url: url)
        return true
    }
    
    func handleMobilePayPaymentWithUrl(url: URL) {
        let result = SwiftFlutterMobilepayPlugin.getResult()!
        MobilePayManager.sharedInstance().handleMobilePayPayment(with: url) { (p: MobilePaySuccessfulPayment?) in
            print("success")
            result("\(p?.orderId);\(p?.amountWithdrawnFromCard);\(p?.transactionId);\(p?.signature)")
        } error: { (e: MobilePayErrorPayment?) in
            result(FlutterError(code: "-1", message: "failure", details: nil))
        } cancel: { (c: MobilePayCancelledPayment?) in
            result(FlutterError(code: "-1", message: "cancelled", details: nil))
        }

    }
}
