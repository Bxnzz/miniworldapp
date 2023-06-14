// import 'package:flutter/cupertino.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

// const OneSignalAppId = "9670ea63-3a61-488a-afcf-8e1be833f631";

// Future<void> initOneSinal() async {
//   final OneSignalShared = OneSignal.shared;

//   OneSignalShared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

//   OneSignalShared.setRequiresUserPrivacyConsent(true);

//   await OneSignalShared.setAppId(OneSignalAppId);
// }

// registerOneSignalEventListener({
//   required Function(OSNotificationOpenedResult) onOpened,
//   required Function(OSNotificationReceivedEvent) onReceivedInForeground,
// }) {
//   final OneSignalShared = OneSignal.shared;

//   OneSignalShared.setNotificationOpenedHandler(onOpened);

//   OneSignalShared.setNotificationWillShowInForegroundHandler(onReceivedInForeground);
//  }
//  const tagName= "userId";
// sendUserTag(int userId) {
//   OneSignal.shared.sendTag(tagName,userId.toString()).then((response){
//    vLog("Successfully sent tags with response: $response");
//   }).catchError(err){
//     vLog("Encountered an error sending tags: $error");
//   });
// }



// deleteUserTag() {}
