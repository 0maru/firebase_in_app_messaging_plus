#import "FirebaseInAppMessagingPlusPlugin.h"
#if __has_include(<firebase_in_app_messaging_plus/firebase_in_app_messaging_plus-Swift.h>)
#import <firebase_in_app_messaging_plus/firebase_in_app_messaging_plus-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "firebase_in_app_messaging_plus-Swift.h"
#endif

@implementation FirebaseInAppMessagingPlusPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFirebaseInAppMessagingPlusPlugin registerWithRegistrar:registrar];
}
@end
