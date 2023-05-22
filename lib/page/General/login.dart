import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/service/provider/appdata.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import '../../model/DTO/loginDTO.dart';
import '../../service/login.dart';
import '../Newhome.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<Login> logins = [];
  List<LoginDto> loginDTOs = [];
  late Future<void> loadDataMethod;
  late LoginService loginService;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _authenticatingStatus = false;

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วยR
    loginService =
        LoginService(Dio(), baseUrl: context.read<AppData>().baseurl);
    // 2.2 async method
    //  loadDataMethod = addData(logins);
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
      child: Container(
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
                                  if (login.data.userId != 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Login Successful')),
                                    );

                                    setState(() {
                                      _authenticatingStatus =
                                          !_authenticatingStatus;
                                    });
                                    log("login success");
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const HomeAll(),
                                          settings: const RouteSettings(
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('login fail try agin!')),
                                    );
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
      ),
    ));
  }
}
