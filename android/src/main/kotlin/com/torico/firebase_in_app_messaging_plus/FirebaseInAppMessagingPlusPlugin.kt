package com.torico.firebase_in_app_messaging_plus

import androidx.annotation.NonNull
import com.google.firebase.inappmessaging.FirebaseInAppMessaging
import com.google.firebase.inappmessaging.FirebaseInAppMessagingClickListener
import com.google.firebase.inappmessaging.model.Action
import com.google.firebase.inappmessaging.model.InAppMessage

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** FirebaseInAppMessagingPlusPlugin */
class FirebaseInAppMessagingPlusPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "torico/firebase_in_app_messaging_plus")

        FirebaseInAppMessaging.getInstance().addClickListener(FIAMClickListener(channel))
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        TODO("Not yet implemented")
    }
}

class FIAMClickListener(channel: MethodChannel) : FirebaseInAppMessagingClickListener {
    private var _channel = channel
    override fun messageClicked(inAppMessage: InAppMessage, action: Action) {
        println(inAppMessage.data)
        println(action)
        if (inAppMessage.campaignMetadata != null) {
            println(inAppMessage.campaignMetadata?.campaignName)
            println(inAppMessage.campaignMetadata?.campaignId)
            val campaignName: String? = inAppMessage.campaignMetadata?.campaignName
            val campaignId: String? = inAppMessage.campaignMetadata?.campaignId
            val campaignInfo: Map<String, String?> = hashMapOf(
                    "campaignName" to campaignName,
                    "campaignId" to campaignId
            )
            val appData: Map<String, Any?> = hashMapOf(
                    "appData" to inAppMessage.data
            )
            val params: Map<Any, Any> = hashMapOf(
                    "campaignInfo" to campaignInfo,
                    "appData" to appData
            )
            _channel.invokeMethod("onMessageSuccess", params)
        } else {
            val params: Map<Any, Any> = hashMapOf()
            _channel.invokeMethod("onMessageError", params)
        }
    }
}
