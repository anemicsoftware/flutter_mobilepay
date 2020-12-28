package net.flowpos.mobilepay.flutter_mobilepay

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat.startActivityForResult
import dk.mobilepay.sdk.CaptureType
import dk.mobilepay.sdk.Country
import dk.mobilepay.sdk.MobilePay
import dk.mobilepay.sdk.ResultCallback
import dk.mobilepay.sdk.model.FailureResult
import dk.mobilepay.sdk.model.Payment
import dk.mobilepay.sdk.model.SuccessResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.math.BigDecimal

/** FlutterMobilepayPlugin */
class FlutterMobilepayPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private lateinit var paymentResult: Result

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var merchantId: String
    private val MOBILEPAY_PAYMENT_REQUEST_CODE = 1001
    private val TAG = "FlutterMobilepayPlugin"
    private lateinit var context: Context
    private lateinit var activity: Activity



    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.i(TAG, "onAttachedToEngine")
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_mobilepay")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext

    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Log.i(TAG, "onMethodCall ${call.method}")
        try {
            if (call.method == "getPlatformVersion") {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            } else if (call.method == "isMobilePayInstalled") {
                result.success(isInstalled(context))
            } else if (call.method == "setup") {
                this.merchantId = call.argument<String>("merchantId")!!
                MobilePay.getInstance().init(this.merchantId, Country.FINLAND);
                //MobilePay.getInstance().captureType = CaptureType.RESERVE
                result.success(true)
            } else if (call.method == "payment") {
                paymentResult = result;
                payment(call.argument<String>("orderId")!!, call.argument<Int>("price")!!)
            } else {
                result.notImplemented()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Exception in method call", e)
            result.error("exception", e.message, e.stackTrace.toString())
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Log.i(TAG, "onDetachedFromEngine")
        channel.setMethodCallHandler(null)
    }

    fun payment(orderId: String, price: Int) {
        val payment = Payment()
        payment.productPrice = BigDecimal(price / 100.0)
        payment.orderId = orderId

        // Create a payment Intent using the Payment object from above.

        // Create a payment Intent using the Payment object from above.
        val paymentIntent: Intent = MobilePay.getInstance().createPaymentIntent(payment)

        // We now jump to MobilePay to complete the transaction. Start MobilePay and wait for the result using an unique result code of your choice.

        // We now jump to MobilePay to complete the transaction. Start MobilePay and wait for the result using an unique result code of your choice.
        startActivityForResult(activity, paymentIntent, MOBILEPAY_PAYMENT_REQUEST_CODE, null)
    }

    fun isInstalled(context: Context): Boolean {
        return MobilePay.getInstance().isMobilePayInstalled(context);
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        //super.onActivityResult(requestCode, resultCode, data)
        Log.i(TAG, "onActivityResult $requestCode")
        if (requestCode == MOBILEPAY_PAYMENT_REQUEST_CODE) {
            // The request code matches our MobilePay Intent
            MobilePay.getInstance().handleResult(resultCode, data, object : ResultCallback {
                override fun onSuccess(result: SuccessResult?) {
                    // The payment succeeded - you can deliver the product.
                    paymentResult.success("${result!!.orderId};${result!!.amountWithdrawnFromCard};${result!!.transactionId};${result!!.signature}")
                }

                override fun onFailure(result: FailureResult?) {
                    // The payment failed - show an appropriate error message to the user. Consult the MobilePay class documentation for possible error codes.
                    paymentResult.error("failure", result?.errorMessage, result?.orderId)
                }

                override fun onCancel(orderId: String?) {
                    // The payment was cancelled.
                    paymentResult.error("cancelled", "", "")
                }
            })
            return true;
        }
        return false;
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.i(TAG, "onAttachedToActivity")
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {
        Log.i(TAG, "onDetachedFromActivity")
    }

    companion object {

    }
}
