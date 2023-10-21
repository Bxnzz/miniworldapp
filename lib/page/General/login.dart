//import 'dart:convert';

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hex/hex.dart';

import 'package:miniworldapp/model/DTO/userDTO.dart';
import 'package:miniworldapp/model/result/raceResult.dart';
import 'package:miniworldapp/page/General/Home.dart';
import 'package:miniworldapp/page/General/const.dart';
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/General/rank_race.dart';

import 'package:miniworldapp/page/Player/chat_room.dart';
import 'package:miniworldapp/page/Player/lobby.dart';
import 'package:miniworldapp/page/Player/player_race_start_hint.dart';
import 'package:miniworldapp/page/Player/player_race_start_mission.detail.dart';
import 'package:miniworldapp/page/Player/review.dart';
import 'package:miniworldapp/service/provider/appdata.dart';
import 'package:miniworldapp/service/user.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:otp/otp.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:toast_notification/ToasterType.dart';
import 'package:toast_notification/toast_notification.dart';
import 'package:base32/base32.dart';

import '../../main.dart';
import '../../model/DTO/loginDTO.dart';
import '../../model/DTO/passwordChengeDTO.dart';
import '../../model/user.dart';
import '../../service/login.dart';
import '../../widget/dialogAlert.dart';
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
  List<User> users = [];
  late Future<void> loadDataMethod;
  late LoginService loginService;
  late UserService userService;
  TextEditingController email = TextEditingController();

  // PersistentTabController index = PersistentTabController() ;

  TextEditingController password = TextEditingController();
  TextEditingController mailReset = TextEditingController();
  TextEditingController pin = TextEditingController();

  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmnewPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _authenticatingStatus = false;
  String _externalUserId = "";
  String _debugLabelString = "";
  String McID = '';
  int IDmc = 0;
  int raceID = 0;
  int idUsers = 0;
  int iduserReset = 0;

  String teamName = '';
  String raceName = '';
  String start = "s";
  String end = "e";
  String userName = '';
  String passwordINDB = '';
  String uri = '';
  String uri2 = '';
  String mailreSet = '';
  int userID = 0;
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  var bytes;
  var digest;
  String oneID = '';

  bool chkPageRoute = false;
  bool isSubmit = false;

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
      // SchedulerBinding.instance.addPostFrameCallback((_) {
      //   Navigator.of(context).pushReplacementNamed("PlayerRaceStartMenu");
      // });
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

  void GetAlertDialogCorrect() {
    Get.defaultDialog(
      title: 'ภารกิจล้มเหลว!!!',
      content: Column(
        children: [
          dialog_alert(
              asset: 'assets/image/failmsg.json', width: 200, height: 200),
        ],
      ),
      cancel: Btn_in_fail_mission(),
    );
  }

  String getGoogleAuthenticatorUri(String appname, String email, String key) {
    List<int> list = utf8.encode(email + key);
    String hex = HEX.encode(list);
    String secret = base32.encodeHexString(hex);
    log('secret $secret');
    uri =
        'otpauth://totp/${Uri.encodeComponent('$appname:$email?secret=$secret&issuer=$appname')}';
    uri2 = 'otpauth://totp/$appname:$email?secret=$secret&issuer=$appname';

    return uri;
  }

  String getTotp(String key) {
    List<int> list = utf8.encode(key);
    String hex = HEX.encode(list);

    String secret = base32.encodeHexString(hex);
    String totp = OTP.generateTOTPCodeString(
        secret, DateTime.now().millisecondsSinceEpoch,
        algorithm: Algorithm.SHA1, isGoogle: true);
    return totp;
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
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/image/BGlogin.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Card(
                            surfaceTintColor: Colors.transparent,
                            elevation: 15,
                            margin: EdgeInsets.fromLTRB(32, 390, 32, 50),
                            color: Colors.white,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text("เข้าสู่ระบบโดย",
                                    style: Get.textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Get.theme.colorScheme.primary)),
                                const SizedBox(
                                  height: 15,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {},
                                        child: Text("รีเซ็ตรหัสผ่าน")),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 40),
                                      child: FaIcon(
                                        FontAwesomeIcons.solidCircleQuestion,
                                        color: Get.theme.colorScheme.primary,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 240,
                                  child: FilledButton(
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
                                                        barrierDismissible:
                                                            false,
                                                        title:
                                                            'เริ่มการแข่งขัน',
                                                        content: Text(
                                                            "การแข่งขันได้เริ่มขึ้นแล้วไปสนุกกัน"),
                                                        confirm: ElevatedButton(
                                                            onPressed: () {
                                                              if (Get.currentRoute ==
                                                                  '/Lobby') {
                                                                Get.back();
                                                                Get.back();

                                                                Get.to(() =>
                                                                    PlayerRaceStartMenu());
                                                              } else {
                                                                Get.back();
                                                                Get.to(() =>
                                                                    PlayerRaceStartMenu());
                                                              }
                                                            },
                                                            child: Text(
                                                                'เข้าการแข่งขัน')))
                                                    .then((value) {
                                                  setState(() {
                                                    loadDataMethod;
                                                  });
                                                });
                                              } else if (additionalData[
                                                          'notitype']
                                                      .toString() ==
                                                  'exitTeam') {
                                                // Get.defaultDialog(
                                                //     title: additionalData[
                                                //         'masseage']);
                                              } else if (additionalData[
                                                          'notitype']
                                                      .toString() ==
                                                  'deleteTeam') {
                                                Get.defaultDialog(
                                                    title: additionalData[
                                                        'masseage']);
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
                                                        cancel:
                                                            Btn_in_success_mission(),
                                                        title:
                                                            'ภารกิจสำเร็จ!!!',
                                                        content: dialog_alert(
                                                            asset:
                                                                'assets/image/correctmsg.json',
                                                            width: 200,
                                                            height: 200),
                                                        barrierDismissible:
                                                            false)
                                                    .then((value) {
                                                  setState(() {
                                                    loadDataMethod;
                                                  });
                                                });
                                              }
                                              //notify mission Fail!!!
                                              else if (event.notification
                                                          .additionalData![
                                                      'notitype'] ==
                                                  'checkUnMis') {
                                                Get.defaultDialog(
                                                        cancel:
                                                            Btn_in_fail_mission(),
                                                        title:
                                                            'ภารกิจล้มเหลว!!!',
                                                        content: Column(
                                                          children: [
                                                            dialog_alert(
                                                                asset:
                                                                    'assets/image/failmsg.json',
                                                                width: 200,
                                                                height: 200),
                                                            Text(
                                                                '${event.notification.additionalData!['masseage']}'),
                                                          ],
                                                        ),
                                                        barrierDismissible:
                                                            false)
                                                    .then((value) {
                                                  setState(() {
                                                    loadDataMethod;
                                                  });
                                                });
                                              } else if (event.notification
                                                          .additionalData![
                                                      'notitype'] ==
                                                  'startgame') {
                                                Get.defaultDialog(
                                                        barrierDismissible:
                                                            false,
                                                        title:
                                                            'เริ่มการแข่งขัน',
                                                        confirm: ElevatedButton(
                                                            onPressed: () {
                                                              if (Get.currentRoute ==
                                                                  '/Lobby') {
                                                                Get.back();
                                                                Get.back();

                                                                Get.to(() =>
                                                                    PlayerRaceStartMenu());
                                                              } else {
                                                                Get.back();
                                                                Get.to(() =>
                                                                    PlayerRaceStartMenu());
                                                              }
                                                            },
                                                            child: Text(
                                                                'เข้าการแข่งขัน')))
                                                    .then((value) {
                                                  setState(() {
                                                    loadDataMethod;
                                                  });
                                                });

                                                // .then(
                                                //   (value) => Get.off(() =>
                                                //     const PlayerRaceStartMenu())
                                                //     );
                                                log('toasttt');

                                                log('ภารกิจจ');
                                              } else if (event.notification
                                                          .additionalData![
                                                      'notitype'] ==
                                                  'deleteTeam') {
                                                raceID = int.parse(event
                                                    .notification
                                                    .additionalData!['raceID']
                                                    .toString());

                                                Get.defaultDialog(
                                                        title:
                                                            'ทีมของคุณออกจากการแข่งขัน!!',
                                                        content: const Text(
                                                            'ทีมของคุณได้ออกจากการแข่งขันนี้แล้ว'))
                                                    .then((value) {
                                                  Get.off(() => Home());
                                                });
                                              } else if (event.notification
                                                          .additionalData![
                                                      'notitype'] ==
                                                  'exitTeam') {
                                                raceID = int.parse(event
                                                    .notification
                                                    .additionalData!['raceID']
                                                    .toString());

                                                teamName = event.notification
                                                        .additionalData![
                                                    'teamName'];

                                                Get.defaultDialog(
                                                        title:
                                                            'มีทีมออกจากการแข่งขัน!!',
                                                        content: Text(
                                                            'ทีม $teamName ได้ออกจากการแข่งขันนี้แล้ว'))
                                                    .then((value) {});
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
                                                  log('mmmmmmmm');
                                                  log('idddd' +
                                                      userId.toString());

                                                  Get.to(() => ChatRoomPage(
                                                      userID: userId,
                                                      raceID: raceID,
                                                      userName: usernames,
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
                                            userId = login.data.userId;
                                            usernames = login.data.userName;
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Home(),
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, right: 20, left: 20),
                                  child: Divider(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('ไม่มีบัญชีผู้ใช้ใช่หรือไม่? '),
                                    TextButton(
                                        onPressed: () {
                                          Get.to(() => FontRegisterPage());
                                        },
                                        child: const Text('คลิกที่นี้'))
                                  ],
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: SizedBox(
                                //     width: 240,
                                //     child: ElevatedButton.icon(
                                //       style: ElevatedButton.styleFrom(
                                //         primary: Color.fromARGB(255, 66, 103,
                                //             178), // Background color
                                //       ),
                                //       onPressed: () {},
                                //       label: Text('Login Facebook',
                                //           style: Get.textTheme.bodyLarge!
                                //               .copyWith(
                                //                   fontWeight: FontWeight.bold,
                                //                   color: Get.theme.colorScheme
                                //                       .onPrimary)),
                                //       icon: FaIcon(
                                //         FontAwesomeIcons.facebook,
                                //         color: Get.theme.colorScheme.onPrimary,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
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

  SizedBox Btn_in_fail_mission() {
    return SizedBox(
      width: Get.width,
      child: ElevatedButton(
          onPressed: () {
            log("outcontext");

            if (Get.currentRoute == '/PlayerRaceStMisDetail') {
              isSubmit = false;
              log("issubmit :$isSubmit");

              Get.back();
              Get.back();
              Get.to(() => PlayerRaceStMisDetail(), fullscreenDialog: true);
            } else if (Get.currentRoute == '/PlayerRaceStartMenu') {
              Get.back();
              Get.to(() => PlayerRaceStMisDetail(), fullscreenDialog: true);
              log("currentroute is ${Get.currentRoute}");
            } else {
              isSubmit = false;
              log("issubmit :$isSubmit");

              Get.back();
              Get.to(() => PlayerRaceStMisDetail(), fullscreenDialog: true);
            }
          },
          child: Text("ทำภารกิจใหม่")),
    );
  }

  SizedBox Btn_in_success_mission() {
    return SizedBox(
      width: Get.width,
      child: ElevatedButton(
          onPressed: () {
            log("outcontext");

            if (Get.currentRoute == '/PlayerRaceStMisDetail') {
              Get.back();
              Get.back();
              Get.back();
              Get.to(() => PlayerRaceStartMenu());
            } else if (Get.currentRoute == '/PlayerRaceStartMenu') {
              Get.back();
              Get.to(() => PlayerRaceStartMenu());
              log("currentroute is ${Get.currentRoute}");
            } else {
              Get.back();
              Get.to(() => PlayerRaceStartMenu());
            }
          },
          child: Text("ตกลง")),
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
  Widget buildPinPut() {
    final defaultPinTheme = PinTheme(
      width: 40,
      height: 40,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(255, 1, 191, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(0, 0, 0, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(255, 194, 247, 1),
      ),
    );

    return Pinput(
        controller: pin,
        disabledPinTheme: defaultPinTheme,
        length: 6,
        focusedPinTheme: focusedPinTheme,
        defaultPinTheme: defaultPinTheme,
        submittedPinTheme: submittedPinTheme,
        closeKeyboardWhenCompleted: true,
        onCompleted: (pin) async {
          if (await _formKey3.currentState!.validate()) {
            log("passKey correct");
            passwordRenew2(context);
            log("passKey correct2");
            mailreSet = mailReset.text;
            var mail = await userService.getUserByEmail(userMail: mailreSet);
            users = mail.data;
            log("id${users.first.userName}");
            iduserReset = users.first.userId;
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'ใส่Pin.';
          }
          if (value != getTotp(mailReset.text)) {
            return 'ใส่ PIN ไม่ถูกต้อง.';
          }

          return null;
        });
  }

  Future<dynamic> passwordRenew2(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: Get.width,
            height: Get.height,
            child: Form(
              key: _formKey2,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
                      controller: newPassword,
                      decoration: InputDecoration(label: Text("รหัสผ่านใหม่")),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ใส่รหัสผ่าน.';
                        }

                        return null;
                      },
                    ),
                    Gap(20),
                    TextFormField(
                      controller: confirmnewPassword,
                      decoration:
                          InputDecoration(label: Text("ยืนยันรหัสผ่าน")),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ยืนยันรหัสผ่าน.';
                        }
                        if (value != newPassword.text) {
                          return 'รหัสยืนยันไม่ถูกต้อง.';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (await _formKey2.currentState!.validate()) {
                            setState(() {});
                            await chengePassword();
                            Get.offAll(() => Login());
                          }
                        },
                        child: Text("เปลี่ยนรหัสผ่าน"))
                  ],
                ),
              ),
            ),
          );
        });
  }

  passwordRenew1() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Form(
        key: _formKey2,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TextFormField(
                controller: newPassword,
                decoration: InputDecoration(label: Text("รหัสผ่านใหม่")),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ใส่รหัสผ่าน.';
                  }

                  return null;
                },
              ),
              Gap(20),
              TextFormField(
                controller: confirmnewPassword,
                decoration: InputDecoration(label: Text("ยืนยันรหัสผ่าน")),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ยืนยันรหัสผ่าน.';
                  }
                  if (value != newPassword.text) {
                    return 'รหัสยืนยันไม่ถูกต้อง.';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (await _formKey3.currentState!.validate()) {
                      setState(() {});
                      await chengePassword();
                      Get.offAll(() => Login());
                    }
                  },
                  child: Text("เปลี่ยนรหัสผ่าน"))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> chengePassword() async {
    late var bytes;
    late var digest;
    bytes = utf8.encode(newPassword.text); // data being hashed
    digest = sha256.convert(bytes);
    PasswordChengeDto passChenge =
        PasswordChengeDto(userPassword: digest.toString());

    var userChangePass = await userService.chengePassword(
      passChenge,
      iduserReset.toString(),
    );
    userResult = userChangePass.data;
  }
}
