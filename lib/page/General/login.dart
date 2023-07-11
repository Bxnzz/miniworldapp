//import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/model/DTO/userDTO.dart';
import 'package:miniworldapp/model/result/raceResult.dart';

import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/Player/lobby.dart';
import 'package:miniworldapp/service/provider/appdata.dart';
import 'package:miniworldapp/service/user.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import '../../model/DTO/loginDTO.dart';
import '../../service/login.dart';
import '../Host/check_mission_Noti.dart';
import '../Newhome.dart';
import 'fontpage_register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late RaceResult userResult;
  List<Login> logins = [];
  List<LoginDto> loginDTOs = [];
  late Future<void> loadDataMethod;
  late LoginService loginService;
  late UserService userService;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _authenticatingStatus = false;
  String _externalUserId = "";
  String _debugLabelString = "";
  String McID = '';
  int IDmc = 0;
  String start = "s";
  String end = "e";

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วยR

    loginService =
        LoginService(Dio(), baseUrl: context.read<AppData>().baseurl);
    userService = UserService(Dio(), baseUrl: context.read<AppData>().baseurl);
    // 2.2 async method
    //  loadDataMethod = addData(logins);
  }

  Future<void> _online() async {
    startLoading(context);
    OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      log("Accepted permission: $accepted}");
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      var additionalData = result.notification.additionalData;
      log('xxxxxxxxx ${additionalData.toString()}');
      //  log('yyyyyy ${additionalData!['notitype'].toString()}');
      if (additionalData!['notitype'] == 'mission') {
        log('zzz');
        additionalData['mcid'];
        Get.to(() => CheckMisNoti(IDmc: int.parse(additionalData['mcid'])));
      } else if (additionalData['notitype'].toString() == 'checkMis') {
        Get.defaultDialog(title: additionalData['masseage']);
      } else if(additionalData['notitype'].toString() == 'endgame'){
         Get.defaultDialog(title: additionalData['masseage']);
      } else {
        log('YYYY');
      }
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      log('FOREGROUND HANDLER CALLED WITH: ${event}');

      /// Display Notification, send null to not display
      event.complete(null);

      // Get.to(() => CheckMisNoti());
      if (event.notification.additionalData!['notitype'] == 'mission') {
        log('dddddd');
        IDmc = int.parse(event.notification.additionalData!['mcid']);
        log('qqqqqqqqqq');
        Get.defaultDialog(
          title: 'มีหลักฐานที่ต้องตรวจสอบ?',
          content: Text(event.notification.additionalData!['mission']),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('ตรวจสอบหลักฐาน'),
              onPressed: () => Get.to(CheckMisNoti(IDmc: int.parse(event.notification.additionalData!['mcid']))),
            ),
          ],
        );

        log('nnnnnnnnnnn');
      }else if(event.notification.additionalData!['notitype'] == 'checkMis'){
         Get.defaultDialog(title: 'ส่งมาละจ้าา');
      }else if(event.notification.additionalData!['notitype'] == 'endgame'){
         Get.defaultDialog(title:event.notification.additionalData!['masseage']).then((value) {
          Get.to(Lobby());
         });
         
      }
    });
    await OneSignal.shared.setAppId("9670ea63-3a61-488a-afcf-8e1be833f631");
    var status = await OneSignal.shared.getDeviceState();

    if (status != null) {
      _externalUserId = status.userId!;
      log('oneID ' + _externalUserId);
    } else {
      log('NO');
    }
    stopLoading();
  }

  @override
  void dispose() {
    email.dispose(); // ยกเลิกการใช้งานที่เกี่ยวข้องทั้งหมดถ้ามี
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: FutureBuilder(
        future: _online(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Colors.purpleAccent,
                  Colors.blue,
                ])),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      //  const Padding(
                      //    padding: EdgeInsets.only(top: 30),
                      //    child: FlutterLogo(
                      //      size: 50,
                      //    ),
                      //  ),
                      //  const Text(
                      //    "Login",
                      //  ),
                      Card(
                        margin: EdgeInsets.fromLTRB(32, 100, 32, 32),
                        color: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "สวัสดี!",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "กรุณาเข้าสู่ระบบด้วยบัญชีของท่าน",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 240,
                                child: TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'กรุณาใส่อีเมล...',
                                      label: Text('อีเมล'),
                                      //  prefixIcon: FaIcon(FontAwesomeIcons.envelope)
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'กรุณากรอกอีเมล';
                                      }
                                      return null;
                                    },
                                    controller: email),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 240,
                                height: 40,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'กรุณาใส่รหัสผ่าน',
                                    label: Text('รหัสผ่าน'),
                                    suffixIcon: IconButton(
                                      // padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        setState(() {
                                          _isHidden =
                                              !_isHidden; // เมื่อกดก็เปลี่ยนค่าตรงกันข้าม
                                        });
                                      },
                                      icon: Icon(
                                        _isHidden // เงื่อนไขการสลับ icon
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกรหัสผ่าน';
                                    }
                                    return null;
                                  },
                                  controller: password,
                                  obscureText: _isHidden,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 240,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    // เปลี่ยนสถานะเป็นกำลังล็อกอิน
                                  
                                    setState(() {
                                      _authenticatingStatus =
                                          !_authenticatingStatus;
                                    });

                                    // อ้างอิงฟอร์มที่กำลังใช้งาน ตรวจสอบความถูกต้องข้อมูลในฟอร์ม
                                    if (_formKey.currentState!.validate()) {
                                      //หากผ่าน
                                      FocusScope.of(context)
                                          .unfocus(); // ยกเลิดโฟกัส ให้แป้นพิมพ์ซ่อนไป
                                      LoginDto dto = LoginDto(
                                          email: email.text,
                                          password: password.text);
                                      
                                      //log(jsonEncode(dto));

                                      var login = await loginService.loginser(dto);
                                      
                                     
                                      UserDto userDto = UserDto(
                                        userName: login.data.userName ,
                                      userDiscription: login.data.userDiscription,
                                      userFullname: login.data.userFullname,
                                      userImage: login.data.userImage,
                                      onesingnalId: _externalUserId,
                                      userMail: login.data.userMail,
                                      );
                                    var updateOnesignal = await userService.updateUsers(userDto, login.data.userId.toString());
                                   // log(jsonEncode(updateOnesignal));
                                     userResult = updateOnesignal.data;
                                    //  log(userResult.toString());
                                        

                                      if (login.data.userId != 0) {
                                      
                                        // ScaffoldMessenger.of(context).showSnackBar(
                                        //   const SnackBar(
                                        //       content: Text('Login Successful')),
                                        // );

                                                  setState(() {
                                                    _authenticatingStatus =
                                                        !_authenticatingStatus;
                                                  });
                                                  log("login success");
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HomeAll(),
                                                        settings:
                                                            const RouteSettings(
                                                                arguments: null),
                                                      ));
                                                  context.read<AppData>().Username =
                                                      login.data.userName;

                                        context.read<AppData>().idUser =
                                            login.data.userId;
                                        //Get.to(() => HomeAll());
                                        // Get.to(() => HomeAll());
                                        return;
                                      } else {
                                        log("login fail");
                                        // ScaffoldMessenger.of(context).showSnackBar(
                                        //   const SnackBar(
                                        //       content:
                                        //           Text('login fail try agin!')),
                                        // );
                                        setState(() {
                                          _authenticatingStatus =
                                              !_authenticatingStatus;
                                        });
                                        return;
                                      }
                                    }
                                  },
                                  child: const Text('เข้าสู่ระบบ')),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('ไม่มีบัญชีใช่หรือไม่?'),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const FontRegisterPage(),
                                            settings: const RouteSettings(
                                                arguments: null),
                                          ));
                                    },
                                    child: const Text('คลิกที่นี้'))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Divider(),
                            ),
                            SizedBox(
                              width: 240,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                label: const Text('Login Facebook'),
                                icon: FaIcon(FontAwesomeIcons.facebook),
                              ),
                            ),
                            SizedBox(
                              width: 240,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                label: const Text('Sign up Facebook'),
                                icon: FaIcon(FontAwesomeIcons.facebook),
                              ),
                            )
                          ],
                        ),
                      ),
                      //      Positioned(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(50),
                      //     child: Container(
                      //       padding: const EdgeInsets.all(16),
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         border:
                      //             Border.all(color: Colors.purple.shade50, width: 3),
                      //         shape: BoxShape.circle,
                      //       ),
                      //       child: const Text('เข้าสู่ระบบ'),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          );
          } return Container();
        },
      ),
    ));
  }
}
