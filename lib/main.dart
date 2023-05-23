import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/General/register.dart';
import 'package:miniworldapp/page/General/login.dart';
import 'package:miniworldapp/page/Host/race_create_pointmap.dart';
import 'package:miniworldapp/page/Player/createTeam.dart';
import 'package:miniworldapp/page/home.dart';
import 'package:miniworldapp/page/loginpage.dart';
import 'package:miniworldapp/page/showmap.dart';
import 'package:miniworldapp/service/provider/appdata.dart';
import 'package:miniworldapp/theme/default.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_facebook_keyhash/flutter_facebook_keyhash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ...

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";

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
  ], child:  MyApp()));
}

class MyApp extends StatelessWidget {
  final DefaultTheme defaultTheme = DefaultTheme();
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     localizationsDelegates: GlobalMaterialLocalizations.delegates,
                  supportedLocales: const [
                    Locale('th', 'TH'),
                  ],
      title: 'Mini world race',
      
      themeMode: ThemeMode.system,
       theme: defaultTheme.flexTheme.theme.copyWith(
                      scaffoldBackgroundColor: Colors.white,
                      inputDecorationTheme: defaultTheme.flexTheme.theme.inputDecorationTheme.copyWith(
                        contentPadding: const EdgeInsets.fromLTRB(6, 10, 6, 3),
                        isDense: true,
                      )),
                  darkTheme: defaultTheme.flexTheme.darkTheme.copyWith(
                      inputDecorationTheme: defaultTheme.flexTheme.darkTheme.inputDecorationTheme.copyWith(
                    contentPadding: const EdgeInsets.fromLTRB(6, 10, 6, 3),
                    isDense: true,
                  )),
    
      home: const Login(),
    );
  }
}
