import Flutter
import UIKit
import FirebaseInAppMessaging

public class SwiftFirebaseInAppMessagingPlusPlugin: NSObject, FlutterPlugin {
  static var fiamMethodChannel: FlutterMethodChannel?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    fiamMethodChannel = FlutterMethodChannel(
      name: "torico/firebase_in_app_messaging_plus",
      binaryMessenger: registrar.messenger())
    let fiamDelegate = FIAMDelegate()
    InAppMessaging.inAppMessaging().delegate = fiamDelegate
  }
}

public class FIAMDelegate: NSObject, InAppMessagingDisplayDelegate {
  public func messageClicked(_ inAppMessage: InAppMessagingDisplayMessage) {
    print("messageClicked")
    let campaignInfo = ["campaignName": inAppMessage.campaignInfo.campaignName, "messageId": inAppMessage.campaignInfo.messageID]
    let data = ["campaignInfo": campaignInfo, "appData": inAppMessage.appData] as [String: Any?]
    SwiftFirebaseInAppMessagingPlusPlugin.fiamMethodChannel?.invokeMethod("onMessageSuccess", arguments: data)
  }
  
  public func messageDismissed(_ inAppMessage: InAppMessagingDisplayMessage, dismissType: FIRInAppMessagingDismissType) {
    print("messageDismissed")
  }
  
  public func impressionDetected(for inAppMessage: InAppMessagingDisplayMessage) {
    print("impressionDetected")
  }
  
  public func displayError(for inAppMessage: InAppMessagingDisplayMessage, error: Error) {
    print("displayError")
    let data = ["code": "", "message": "\(error)", "detail": ""]
    SwiftFirebaseInAppMessagingPlusPlugin.fiamMethodChannel?.invokeMethod("onMessageError", arguments: data)
  }
}

