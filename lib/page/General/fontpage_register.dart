import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gap/gap.dart';
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
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController description = TextEditingController();
  String idFacebook = '';
  String image = '';
  final _formKey = GlobalKey<FormState>();
  late RegisterService registerService;

  File? pickedFile;
  bool isImage = true;

  late Image? img;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerService =
        RegisterService(Dio(), baseUrl: context.read<AppData>().baseurl);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size * 0.20;

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    selectFile();
                    log('message');
                  },
                  child: pickedFile != null
                      ? CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.20,
                          backgroundImage: FileImage(pickedFile!))
                      : CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.20,
                          child: GestureDetector(
                            onTap: () {
                              selectFile();
                              log('message');
                            },
                            child: Icon(
                              Icons.add_photo_alternate,
                              size: MediaQuery.of(context).size.width * 0.20,
                            ),
                          ),
                        ),
                ),
                Gap(20),
                TextFormField(
                  controller: userName,
                  decoration: const InputDecoration(
                    hintText: 'ชื่อในระบบ',
                    icon: Icon(Icons.account_box_sharp),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่ชื่อในระบบ.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    hintText: 'อีเมลล์',
                    icon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่อีเมลล์.';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return "กรุณาใส่อีเมลล์ให้ถูกต้อง";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: password,
                  decoration: const InputDecoration(
                    hintText: 'รหัสผ่าน',
                    icon: Icon(Icons.password),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่รหัสผ่าน.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: confirmpassword,
                  decoration: const InputDecoration(
                    hintText: 'ยืนยันรหัสผ่าน',
                    icon: Icon(Icons.password),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ยืนยันรหัสผ่าน.';
                    }
                    if (value != password.text) {
                      return 'รหัสยืนยันไม่ถูกต้อง.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                    controller: fullname,
                    decoration: const InputDecoration(
                      hintText: 'ชื่อ-นามสกุล',
                      icon: Icon(Icons.text_decrease_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาใส่ชื่อ-นามสกุล.';
                      }
                      return null;
                    }),
                TextFormField(
                  controller: description,
                  decoration: const InputDecoration(
                    hintText: 'คำอธิบาย',
                    icon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ใส่คำอธิบายตัวคุณพอสังเขป.';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
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
                                  settings:
                                      const RouteSettings(arguments: null),
                                ));
                            if (register.data.massage == "Register failed") {
                              log("Register failed");
                            }
                          }
                        },
                        child: Text('ลงทะเบียน')),
                    Gap(50),
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
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    File file;
    PlatformFile platFile;
    if (result == null) return;
    platFile = result.files.single;
    file = File(platFile.path!);
    pickedFile = file;

    log(result.files.single.toString());
    log(platFile.extension.toString());
    if (platFile.extension == 'jpg' || platFile.extension == 'png') {
      setState(() {
        isImage = true;
      });
    } else {
      isImage = false;
    }
  }
}
