package com.ltimindtree.rd_service_flutter

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

import android.app.Activity
import android.content.Intent
import android.provider.ContactsContract
import java.util.*
import android.os.Bundle

/** RdServiceFlutterPlugin */
class RdServiceFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity

    private val CAPTURE_REQ_CODE = 123
    private val CAPTURE_INTENT_RESPONSE_DATA = ""
    private val ENVIRONMENT_TAG = "P"   // For Prod
    // var ENVIRONMENT_TAG = "PP" //For pre prod
    // var ENVIRONMENT_TAG = "s" //STAGING
    private val  LANGUAGE = ""
    private val WADH_KEY = ""

    private lateinit var channel: MethodChannel
    val PICK_CONTACT_RESULT_CODE = 36
    var act: Activity? = null
    private lateinit var result: Result

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "rd_service_flutter")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        this.result = result;
        if (call.method == "getAContact") {
            val intent = Intent(Intent.ACTION_PICK, ContactsContract.Contacts.CONTENT_URI)
            act?.startActivityForResult(intent, PICK_CONTACT_RESULT_CODE)
        } else if (call.method == "checkIntentPresent") {
            var action : String? = call.argument("action")
            val intent = Intent(action)
            if (intent.resolveActivity(act!!.packageManager) != null) {
                result.success(true)
            } else {
                result.success(false)
            }
        } else if (call.method == "getRDServicePID") {
            // var environmentTag: String? = call.argument("environmentTag")
            // var wadhKey: String? = call.argument("wadhKey")

            val intent = Intent("in.gov.uidai.rdservice.face.CAPTURE")
            intent.putExtra(
                "request",
                createPidOptionForAuth(WADH_KEY, ENVIRONMENT_TAG)
            )
            act?.startActivityForResult(intent, CAPTURE_REQ_CODE)
        } else if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        act = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        act = null;
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        act = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        act = null;
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == PICK_CONTACT_RESULT_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                if (data != null) {
                    val contactData = data.data
                    val c = act!!.contentResolver.query(contactData!!, null, null, null, null)
                    if (c!!.moveToFirst()) {
                        val name =
                            c.getString(c.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME))
                        result.success(name)
                        return true
                    }
                }
            }
        } else if (requestCode == CAPTURE_REQ_CODE && resultCode == Activity.RESULT_OK) {
            if (data != null) {
                val d = data.getStringExtra(CAPTURE_INTENT_RESPONSE_DATA)
                result.success(d)
                return true
            }
        }
        return false
    }

    fun createPidOptionForAuth(wadh: String, environmentTag: String): String {
        return createPidOptions(wadh, generateTxnID(), "auth", environmentTag)
    }

    private fun generateTxnID(): String {
        val random = Random()
        return String.format("%04d", random.nextInt(10000))
    }

    private fun createPidOptions(
        wadh: String,
        txnId: String,
        purpose: String,
        environmentTag: String
    ): String {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                "<PidOptions ver=\"2.0\" env=\"$environmentTag\">\n" +
                "   <Opts fCount=\"\" fType=\"\" iCount=\"\" iType=\"\" pCount=\"\" pType=\"\" format=\"\" pidVer=\"2.0\" timeout=\"\" otp=\"\" wadh=\"${wadh}\" posh=\"\" />\n" +
                "   <CustOpts>\n" +
                "      <Param name=\"txnId\" value=\"${txnId}\"/>\n" +
                "      <Param name=\"purpose\" value=\"$purpose\"/>\n" +
                "      <Param name=\"language\" value=\"$LANGUAGE\"/>\n" +
                "   </CustOpts>\n" +
                "</PidOptions>"
    }

}
