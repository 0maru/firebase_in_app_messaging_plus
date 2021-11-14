import 'package:flutter/services.dart';

const _methodName = 'torico/firebase_in_app_messaging_handler';

typedef OnMessageSuccessCallback = Future<dynamic> Function(
    MessagingData? data);
typedef OnMessageErrorCallback = Future<dynamic> Function(
    MessagingException error);

class FirebaseInAppMessagingHandler {
  FirebaseInAppMessagingHandler._();

  static const MethodChannel channel = MethodChannel(_methodName);

  static final FirebaseInAppMessagingHandler instance =
      FirebaseInAppMessagingHandler._();

  OnMessageSuccessCallback? _onMessageSuccess;
  OnMessageErrorCallback? _onMessageError;

  Future<dynamic> listen({
    OnMessageSuccessCallback? onSuccess,
    OnMessageErrorCallback? onError,
  }) async {
    _onMessageSuccess = onSuccess;
    _onMessageError = onError;
    channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onMessageSuccess':
        MessagingData? data;
        if (call.arguments != null) {
          data = convertJsonToObject(call.arguments as Map<dynamic, dynamic>);
        }
        return _onMessageSuccess!(data);
      case 'onMessageError':
        final data = call.arguments as Map<dynamic, dynamic>;
        final error = MessagingException._(
          data['code'].toString(),
          data['message'].toString(),
          data['detail'],
        );
        return _onMessageError!(error);
    }
  }

  MessagingData? convertJsonToObject(Map<dynamic, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final campaignInfo =
        data.containsKey('campaignInfo') ? data['campaignInfo'] : {};
    final appData = data.containsKey('appData') ? data['appData'] : {};
    return MessagingData._(
      campaignInfo as Map<dynamic, dynamic>,
      appData as Map<dynamic, dynamic>,
    );
  }
}

class MessagingData {
  MessagingData._(
    this.campaignInfo,
    this.appData,
  );

  final Map<dynamic, dynamic>? campaignInfo;
  final Map<dynamic, dynamic>? appData;
}

class MessagingCampaignInfo {
  MessagingCampaignInfo._(
    this.campaignName,
    this.messageId,
  );

  final String campaignName;
  final String messageId;
}

class MessagingException extends PlatformException {
  MessagingException._(
    String code,
    String? message,
    dynamic detail,
  ) : super(
          code: code,
          message: message,
          details: detail,
        );
}
