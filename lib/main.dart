import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/General/register.dart';
import 'package:miniworldapp/page/General/login.dart';
import 'package:miniworldapp/page/Host/mission_create.dart';
import 'package:miniworldapp/page/Player/createTeam.dart';
import 'package:miniworldapp/page/home.dart';
import 'package:miniworldapp/page/loginpage.dart';
import 'package:miniworldapp/page/showmap.dart';
import 'package:miniworldapp/service/provider/appdata.dart';
import 'package:miniworldapp/theme/default.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'firebase_options.dart';
import 'package:flutter_facebook_keyhash/flutter_facebook_keyhash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
// ...
final DefaultTheme defaultTheme = DefaultTheme();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";

  // String userId = await connectOneSignal();
  // log('User ID: $userId');

  // initializeDateFormatting();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
  //Generate Key on device a build app
  // String? key = await FlutterFacebookKeyhash.getFaceBookKeyHash ??
  //     'Unknown platform version';
  // print(key ?? "");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => AppData(),
    )
  ], child: MyApp()));
}

Future<String> connectOneSignal({int timeout = 20}) async {
   OneSignal.shared
          .promptUserForPushNotificationPermission()
          .then((accepted) {
        log("Accepted permission: $accepted}");
      });
  await OneSignal.shared.setAppId("9670ea63-3a61-488a-afcf-8e1be833f631");
  await OneSignal.shared.disablePush(true);
  String userID = '';
  // Fresh install has to wait to get DeviceState (~10 sec)
  for (var i = 0; i < timeout; i++) {
    await Future.delayed(const Duration(
      seconds: 1,
    ));
    log(i.toString());
    var deviceState = await OneSignal.shared.getDeviceState();
    if (deviceState != null && deviceState.userId != null) {
      userID = deviceState.userId!;
      break;
    }
  }
  return userID;
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // here
      navigatorObservers: [FlutterSmartDialog.observer],
      // here
      builder: FlutterSmartDialog.init(),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('th', 'TH'),
      ],
      title: 'Mini world race',
      themeMode: ThemeMode.light,
      theme: defaultTheme.flexTheme.theme.copyWith(
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme:
            defaultTheme.flexTheme.theme.inputDecorationTheme.copyWith(
          contentPadding: const EdgeInsets.fromLTRB(6, 10, 6, 3),
          isDense: true,
        ),
        textTheme: defaultTheme.flexTheme.theme.textTheme.copyWith(
          bodySmall: defaultTheme.flexTheme.theme.textTheme.bodySmall!
              .copyWith(fontSize: 14),
          bodyMedium: defaultTheme.flexTheme.theme.textTheme.bodyMedium!
              .copyWith(fontSize: 15),
          bodyLarge: defaultTheme.flexTheme.theme.textTheme.bodyLarge!
              .copyWith(fontSize: 16),
          titleMedium: defaultTheme.flexTheme.theme.textTheme.titleMedium!
              .copyWith(fontSize: 20),
          titleLarge: defaultTheme.flexTheme.theme.textTheme.titleLarge!
              .copyWith(fontSize: 24),
        ),
      ),

      darkTheme: defaultTheme.flexTheme.darkTheme.copyWith(
          inputDecorationTheme:
              defaultTheme.flexTheme.darkTheme.inputDecorationTheme.copyWith(
        contentPadding: const EdgeInsets.fromLTRB(6, 10, 6, 3),
        isDense: true,
      )),
      home: const Login(),
    );
  }
}
