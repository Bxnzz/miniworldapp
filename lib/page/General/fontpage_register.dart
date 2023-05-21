import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/General/login.dart';
import 'package:provider/provider.dart';

import '../../model/DTO/registerDTO.dart';
import '../../service/Register.dart';
import '../../service/provider/appdata.dart';

class FontRegisterPage extends StatefulWidget {
  const FontRegisterPage({super.key});

  @override
  State<FontRegisterPage> createState() => _FontRegisterPageState();
}

class _FontRegisterPageState extends State<FontRegisterPage> {
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController description = TextEditingController();
  String idFacebook = '';
  String image = '';

  late RegisterService registerService;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerService =
        RegisterService(Dio(), baseUrl: context.read<AppData>().baseurl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Form(
        child: Column(
          children: [
            TextFormField(
              controller: userName,
              decoration: const InputDecoration(
                hintText: 'ชื่อในระบบ',
                icon: Icon(Icons.account_box_sharp),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'อีเมลล์',
                icon: Icon(Icons.email_outlined),
              ),
              controller: email,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'รหัสผ่าน',
                icon: Icon(Icons.password),
              ),
              controller: password,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'ชื่อ-นามสกุล',
                icon: Icon(Icons.text_decrease_outlined),
              ),
              controller: fullname,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'รูปภาพ',
                icon: Icon(Icons.image),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'คำอธิบาย',
                icon: Icon(Icons.email_outlined),
              ),
              controller: description,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      RegisterDto dto = RegisterDto(
                          userName: userName.text,
                          userMail: email.text,
                          userPassword: password.text,
                          userFullname: fullname.text,
                          userDiscription: description.text,
                          userFacebookId: idFacebook,
                          userImage: image);
                      log(jsonEncode(dto));

                      var register = await registerService.registers(dto);

                      log(jsonEncode(register.data));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                            settings: const RouteSettings(arguments: null),
                          ));
                    },
                    child: Text('ลงทะเบียน')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                            settings: const RouteSettings(arguments: null),
                          ));
                    },
                    child: Text('ยกเลิก'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
