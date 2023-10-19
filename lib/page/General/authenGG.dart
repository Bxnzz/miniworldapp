import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hex/hex.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:miniworldapp/page/General/const.dart';
import 'package:miniworldapp/page/General/login.dart';
import 'package:otp/otp.dart';
import 'package:provider/provider.dart';
import 'package:base32/base32.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/user.dart';
import '../../service/provider/appdata.dart';
import '../../service/user.dart';
import '../../widget/loadData.dart';

class AuthenGG extends StatefulWidget {
  const AuthenGG({super.key});

  @override
  State<AuthenGG> createState() => _AuthenGGState();
}

class _AuthenGGState extends State<AuthenGG> {
  late Future<void> loadData;
  late UserService userservice;
  late List<User> users;
  String userMail = '';
  String userPass = '';
  String uri = '';
  String uri2 = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userservice = UserService(Dio(), baseUrl: context.read<AppData>().baseurl);
    uri = context.read<AppData>().authenUri;
    log("provider${context.read<AppData>().authenUname}");
    userMail = context.read<AppData>().authenUMail;
    userPass = context.read<AppData>().authenUPass;
    loadData = LoadData();
  }

  Future LoadData() async {
    startLoading(context);
    try {
      /// log("userName is $userName");
      //var usersByName = await userservice.getUserByName(userName: userName);
      //users = usersByName.data;

      // log("usesrByname = ${users}");
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
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
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("สมัครสมาชิก 2/2"),
          ),
          body: Center(
            child: Column(
              children: [
                // TextButton(
                //     onPressed: () {
                //       getGoogleAuthenticatorUri(
                //           "mnrace", userMail, userPass);
                //       log(getTotp(userMail + userPass));

                //     },
                //     child: Text('ลงทะเบียน Google Authenicator')),

                Gap(20),
                Text(
                  "สแกน QRCODE\nแอบพลิเคชั่น \"Authenticator\"",
                  textAlign: TextAlign.center,
                  style: Get.theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 20,
                  ),
                ),
                Text(
                    textAlign: TextAlign.center,
                    "ลงทะเบียนสำหรับการรีเซ็ทหรือเปลี่ยนรหัสผ่าน\nในอนาคตของคุณ"),
                Gap(20),
                Image.network(
                    'https://www.google.com/chart?chs=200x200&chld=M|0&cht=qr&chl=$uri'),
                Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: TextButton(
                      onPressed: () async {
                        getGoogleAuthenticatorUri("mnrace", userMail, userPass);
                        AppInfo app = await InstalledApps.getAppInfo(
                            'com.google.android.apps.authenticator2');
                        if (app.name!.isEmpty) {
                          log('Not installed. Show QR');
                        } else {
                          log(app.name!);
                          await launchUrl(Uri.parse(uri2));
                        }
                        //  await launchUrl(Uri.parse(uri2));
                      },
                      child: Text("เปิด Authenicator")),
                ),

                Gap(250),
                ElevatedButton(
                    onPressed: () {
                      Get.off(() => Login());
                    },
                    child: Text("เสร็จสิ้น"))
              ],
            ),
          )),
    );
  }

  Future<dynamic> regisOTP(BuildContext context) {
    return showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: _formKey,
              child: Container(
                width: Get.width,
                height: Get.height,
                child: Column(
                  children: [
                    Gap(20),
                    Text(
                      "สแกน QRCODE\nแอบพลิเคชั่น \"Authenicator\"",
                      textAlign: TextAlign.center,
                      style: Get.theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                        fontSize: 20,
                      ),
                    ),
                    Gap(20),
                    Image.network(
                        'https://www.google.com/chart?chs=200x200&chld=M|0&cht=qr&chl=$uri'),
                    Padding(
                      padding: const EdgeInsets.only(left: 70),
                      child: TextButton(
                          onPressed: () async {
                            AppInfo app = await InstalledApps.getAppInfo(
                                'com.google.android.apps.authenticator2');
                            if (app.name!.isEmpty) {
                              log('Not installed. Show QR');
                            } else {
                              log(app.name!);
                              await launchUrl(Uri.parse(uri2));
                            }
                            //  await launchUrl(Uri.parse(uri2));
                          },
                          child: Text("เปิด Authenicator")),
                    ),

                    Gap(20),

                    // ElevatedButton(
                    //     onPressed: () async {
                    //       log(getTotp(userMail.text + users.first.userPassword));

                    //       if (await _formKey.currentState!.validate()) {
                    //         passwordRenew(context);
                    //       }
                    //     },
                    //     child: Text("ยืนยัน"))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
