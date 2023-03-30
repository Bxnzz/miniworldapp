import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: FlutterLogo(
                      size: 50,
                    ),
                  ),
                  const Text(
                    "Login",
                  ),
                  TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        icon: Icon(Icons.email_outlined),
                      ),
                      controller: email),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      icon: const Icon(Icons.vpn_key),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isHidden =
                                !_isHidden; // เมื่อกดก็เปลี่ยนค่าตรงกันข้าม
                          });
                        },
                        icon: Icon(_isHidden // เงื่อนไขการสลับ icon
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                    controller: password,
                    obscureText: _isHidden,
                  ),
                  Visibility(
                      visible: !_authenticatingStatus,
                      child: ElevatedButton(
                          onPressed: () async {
                            // เปลี่ยนสถานะเป็นกำลังล็อกอิน
                            setState(() {
                              _authenticatingStatus = !_authenticatingStatus;
                            });

                            // อ้างอิงฟอร์มที่กำลังใช้งาน ตรวจสอบความถูกต้องข้อมูลในฟอร์ม
                            if (_formKey.currentState!.validate()) {
                              //หากผ่าน
                              FocusScope.of(context)
                                  .unfocus(); // ยกเลิดโฟกัส ให้แป้นพิมพ์ซ่อนไป
                              LoginDto dto = LoginDto(
                                  email: email.text, password: password.text);
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
                                      settings:
                                          const RouteSettings(arguments: null),
                                    ));
                                context.read<AppData>().Username =
                                    login.data.userName;
                                //Get.to(() => HomeAll());
                                // Get.to(() => HomeAll());
                                return;
                              } else {
                                log("login fail");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('login fail try agin!')),
                                );
                                setState(() {
                                  _authenticatingStatus =
                                      !_authenticatingStatus;
                                });
                                return;
                              }
                            }
                          },
                          child: const Text('LOGIN')))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
