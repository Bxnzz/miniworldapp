//import 'dart:convert';

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:miniworldapp/model/DTO/userDTO.dart';
import 'package:miniworldapp/model/result/raceResult.dart';
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/General/rank_race.dart';

import 'package:miniworldapp/page/Player/chat_room.dart';
import 'package:miniworldapp/page/Player/lobby.dart';
import 'package:miniworldapp/page/Player/player_race_start_hint.dart';
import 'package:miniworldapp/page/Player/review.dart';
import 'package:miniworldapp/service/provider/appdata.dart';
import 'package:miniworldapp/service/user.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:toast_notification/ToasterType.dart';
import 'package:toast_notification/toast_notification.dart';

import '../../main.dart';
import '../../model/DTO/loginDTO.dart';
import '../../service/login.dart';
import '../Host/approve_mission.dart';
import '../Newhome.dart';
import '../Player/player_race_start_menu.dart';
import 'fontpage_register.dart';
import 'package:crypto/crypto.dart';



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

  // PersistentTabController index = PersistentTabController() ;

  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _authenticatingStatus = false;
  String _externalUserId = "";
  String _debugLabelString = "";
  String McID = '';
  int IDmc = 0;
  int raceID = 0;
  String raceName = '';
  String start = "s";
  String end = "e";
  String userName = '';
  String passwordINDB = '';
  int userID = 0;
  var bytes;
  var digest;
  String oneID = '';

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วยR

    loginService =
        LoginService(Dio(), baseUrl: context.read<AppData>().baseurl);
    userService = UserService(Dio(), baseUrl: context.read<AppData>().baseurl);
    // 2.2 async method
    loadDataMethod = _online();
  }

  Future<void> _online() async {
    startLoading(context);
    try {
      var a = await userService.getUserAll();
      a.data;
      var userName = a.data.first.userName;

      OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
      oneID = await connectOneSignal();
      log('User ID: $oneID');

      var one = await userService.updateOneID(oneID);
    } catch (e) {
      log("err:" + e.printError.toString());
    } finally {
      stopLoading();
    }
  }

  @override
  void dispose() {
    email.dispose(); // ยกเลิกการใช้งานที่เกี่ยวข้องทั้งหมดถ้ามี
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          body: SingleChildScrollView(
        child: FutureBuilder(
          future: loadDataMethod,
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
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
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
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40),
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
                                Gap(20),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'กรุณาใส่รหัสผ่าน',
                                      label: Text('รหัสผ่าน'),
                                      suffixIcon: IconButton(
                                        // padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          setState(() {
                                            _isHidden = !_isHidden;
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 150,
                                  ),
                                  child: TextButton(
                                      onPressed: () {},
                                      child: Text("รีเซ็ตรหัสผ่าน")),
                                ),
                                SizedBox(
                                  width: 240,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        // เปลี่ยนสถานะเป็นกำลังล็อกอิน
                                        passwordINDB = password.text;
                                        bytes = utf8.encode(
                                            passwordINDB); // data being hashed
                                        log("byte $bytes");
                                        digest = sha256.convert(bytes);

                                        log(digest.toString());
                                        // อ้างอิงฟอร์มที่กำลังใช้งาน ตรวจสอบความถูกต้องข้อมูลในฟอร์ม
                                        if (_formKey.currentState!.validate()) {
                                          //หากผ่าน
                                          FocusScope.of(context)
                                              .unfocus(); // ยกเลิดโฟกัส ให้แป้นพิมพ์ซ่อนไป
                                          LoginDto dto = LoginDto(
                                              email: email.text,
                                              password: digest.toString());

                                          //log(jsonEncode(dto));

                                          var login =
                                              await loginService.loginser(dto);

                                          if (login.data.userId != 0) {
                                            OneSignal.shared
                                                .setNotificationOpenedHandler(
                                                    (OSNotificationOpenedResult
                                                        result) {
                                              var additionalData = result
                                                  .notification.additionalData;
                                              log('xxxxxxxxx ${additionalData.toString()}');
                                              //  log('yyyyyy ${additionalData!['notitype'].toString()}');
                                              if (additionalData!['notitype'] ==
                                                  'mission') {
                                                log('zzz');
                                                additionalData['mcid'];
                                                Get.to(() => ApproveMission(
                                                    IDmc: int.parse(
                                                        additionalData[
                                                            'mcid'])));
                                              } else if (additionalData[
                                                          'notitype']
                                                      .toString() ==
                                                  'checkMis') {
                                                Get.defaultDialog(
                                                    title: additionalData[
                                                        'masseage']);
                                              } else if (additionalData[
                                                          'notitype']
                                                      .toString() ==
                                                  'startgame') {
                                                Get.defaultDialog(
                                                    title: 'เริ่มการแข่งขัน');
                                              } else if (additionalData[
                                                          'notitype']
                                                      .toString() ==
                                                  'endgame') {
                                                Get.defaultDialog(
                                                    title: additionalData[
                                                        'masseage']);
                                              } else if (additionalData[
                                                          'notitype']
                                                      .toString() ==
                                                  'processgame') {
                                                Get.defaultDialog(
                                                    title: additionalData[
                                                        'masseage']);
                                              } else {
                                                log('YYYY');
                                              }
                                            });

                                            OneSignal.shared
                                                .setNotificationWillShowInForegroundHandler(
                                                    (OSNotificationReceivedEvent
                                                        event) {
                                              log('qqqqq' +
                                                  'FOREGROUND HANDLER CALLED WITH: ${event.notification.additionalData}');

                                              /// Display Notification, send null to not display
                                              event.complete(null);

                                              // Get.to(() => CheckMisNoti());
                                              if (event.notification
                                                          .additionalData![
                                                      'notitype'] ==
                                                  'mission') {
                                                log('dddddd');
                                                IDmc = int.parse(event
                                                    .notification
                                                    .additionalData!['mcid']);
                                                log('qqqqqqqqqq');
                                               
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "มีหลักฐานที่ต้องตรวจสอบ?\n ภารกิจ: ${event.notification.additionalData!['mission']} ทีม: ${event.notification.additionalData!['team']}       ",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIosWeb: 3,
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);

                                                log('nnnnnnnnnnn');
                                              } else if (event.notification
                                                          .additionalData![
                                                      'notitype'] ==
                                                  'checkMis') {
                                               
                                                Get.defaultDialog(
                                                        title:
                                                            'ทำภารกิจสำเร็จ!!!')
                                                    .then((value) => Get.to(() =>
                                                        PlayerRaceStartMenu()));
                                              } else if (event.notification
                                                          .additionalData![
                                                      'notitype'] ==
                                                  'checkUnMis') {
                                                Get.defaultDialog(
                                                        title:
                                                            'ทำภารกิจไม่สำเร็จ!!!',
                                                        content: Text(
                                                            '${event.notification.additionalData!['masseage']}'))
                                                    .then((value) => Get.to(() =>
                                                        PlayerRaceStartMenu()));
                                              } else if (event.notification
                                                          .additionalData![
                                                      'notitype'] ==
                                                  'startgame') {
                                                Get.defaultDialog(
                                                        title:
                                                            'เริ่มการแข่งขัน')
                                                    .then((value) => Get.to(() =>
                                                        PlayerRaceStartMenu()));
                                                log('toasttt');

                                                log('ภารกิจจ');
                                              } else if (event.notification
                                                          .additionalData![
                                                      'notitype'] ==
                                                  'endgame') {
                                                raceName = event.notification
                                                        .additionalData![
                                                    'raceName'];

                                                raceID = int.parse(event
                                                    .notification
                                                    .additionalData!['raceID']
                                                    .toString());

                                                Get.defaultDialog(
                                                        title: 'จบการแข่งขัน',
                                                        content: const Text(
                                                            'รอการประมวลผล'))
                                                    .then((value) {
                                                  Get.to(() => ChatRoomPage(
                                                      userID: userID,
                                                      raceID: raceID,
                                                      userName: userName,
                                                      raceName: raceName));
                                                });
                                              } else if (event.notification
                                                          .additionalData![
                                                      'notitype'] ==
                                                  'processgame') {
                                                raceName = event.notification
                                                        .additionalData![
                                                    'raceName'];
                                                raceID = int.parse(event
                                                    .notification
                                                    .additionalData!['raceID']
                                                    .toString());
                                                Get.defaultDialog(
                                                        title: 'จบการแข่งขัน',
                                                        content: Text(
                                                            'ประมวลผลเสร็จสิ้น'))
                                                    .then((value) => Get.to(
                                                        () => RankRace()));
                                                // AwesomeDialog(
                                                //   context: context,
                                                //   dialogType:
                                                //       DialogType.success,
                                                //   animType: AnimType.rightSlide,
                                                //   headerAnimationLoop: false,
                                                //   title: 'จบการแข่งขัน',
                                                //   desc:
                                                //       'ประมวลผลการแข่งขันเสร็จสิ้น',
                                                // ).show().then((value) =>
                                                //     Get.to(RankRace()));
                                              }
                                            });
                                            var deviceState = await OneSignal
                                                .shared
                                                .getDeviceState();
                                            if (deviceState != null &&
                                                deviceState.userId != null) {
                                              //   _externalUserId = status.userId!;

                                              _externalUserId =
                                                  deviceState.userId!;
                                              log('oneID ' + _externalUserId);
                                            }

                                            OneSignal.shared.disablePush(false);
                                            UserDto userDto = UserDto(
                                              userName: login.data.userName,
                                              userDiscription:
                                                  login.data.userDiscription,
                                              userFullname:
                                                  login.data.userFullname,
                                              userImage: login.data.userImage,
                                              onesingnalId: _externalUserId,
                                              userMail: login.data.userMail,
                                            );

                                            var updateOnesignal =
                                                await userService.updateUsers(
                                                    userDto,
                                                    login.data.userId
                                                        .toString());
                                            // log(jsonEncode(updateOnesignal));
                                            userResult = updateOnesignal.data;
                                            //  log(userResult.toString());
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
                                                  settings: const RouteSettings(
                                                      arguments: null),
                                                ));
                                            context.read<AppData>().Username =
                                                login.data.userName;

                                            context.read<AppData>().idUser =
                                                login.data.userId;
                                            context.read<AppData>().userImage =
                                                login.data.userImage;
                                            context
                                                    .read<AppData>()
                                                    .userFullName =
                                                login.data.userFullname;
                                            context
                                                    .read<AppData>()
                                                    .userDescrip =
                                                login.data.userDiscription;

                                            context.read<AppData>().oneID =
                                                _externalUserId;
                                            return;
                                          } else {
                                            final snackBar = SnackBar(
                                              content: const Text(
                                                  'เข้าสู่ระบบล้มเหลว อีเมลหรือรหัสผ่านไม่ถูก'),
                                            );

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);

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
                                          Get.to(() => FontRegisterPage());
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
            }
            return Container();
          },
        ),
      )),
    );
  }

  // void _dialogLocation() async {
  //   locationDialog({
  //     required AlignmentGeometry alignment,
  //     double width = double.infinity,
  //     double height = double.infinity,
  //   }) async {
  //     SmartDialog.show(
  //         alignment: alignment,
  //         builder: (context) {
  //           return Container(
  //             width: Get.width,
  //             height: Get.height,
  //             child: Text("asdfasdf"),
  //           );
  //         });
  //     await Future.delayed(Duration(milliseconds: 500));
  //   }

  //   //top
  //   await locationDialog(height: 70, alignment: Alignment.topCenter);
  // }
}
