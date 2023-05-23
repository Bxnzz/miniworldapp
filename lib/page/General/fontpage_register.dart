import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
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

  TextEditingController testss = TextEditingController();
  String idFacebook = '';
  String image = '';
  final _formKey = GlobalKey<FormState>();
  final avata = GlobalKey<FormState>();
  late RegisterService registerService;

  File? pickedFile;
  UploadTask? uploadTask;
  bool isImage = true;

  String img = '';

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
                            key: avata,
                            radius: MediaQuery.of(context).size.width * 0.15,
                            backgroundImage: FileImage(pickedFile!))
                        : CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.15,
                            child: GestureDetector(
                              onTap: () {
                                selectFile();
                                log('message');
                              },
                              child: Icon(
                                Icons.add_photo_alternate,
                                size: MediaQuery.of(context).size.width * 0.15,
                              ),
                            ),
                          )),
                Gap(20),
                SizedBox(
                  child: textField(userName, '', 'ชื่อในระบบ',
                      'กรุณาใส่ชื่อในระบบ', Icon(Icons.account_box_sharp)),
                ),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: 'อีเมลล์',
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
                Gap(15),
                TextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: password,
                  decoration: const InputDecoration(
                    labelText: 'รหัสผ่าน',
                    icon: Icon(Icons.password),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่รหัสผ่าน.';
                    }
                    return null;
                  },
                ),
                Gap(15),
                TextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: confirmpassword,
                  decoration: const InputDecoration(
                    labelText: 'ยืนยันรหัสผ่าน',
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
                Gap(15),
                SizedBox(
                  child: textField(
                      fullname,
                      '',
                      'ชื่อ-นามสกุล',
                      'กรุณาใส่ชื่อ-นามสกุล.',
                      Icon(Icons.text_decrease_outlined)),
                ),
                SizedBox(
                  child: textField(
                    description,
                    '',
                    'คำอธิบาย',
                    'ใส่คำอธิบายตัวคุณพอสังเขป',
                    Icon(Icons.email_outlined),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (await _formKey.currentState!.validate()) {
                            setState(() {
                              uploadFile();
                            });

                            // RegisterDto dto = RegisterDto(
                            //     userName: userName.text,
                            //     userMail: email.text,
                            //     userPassword: password.text,
                            //     userFullname: fullname.text,
                            //     userDiscription: description.text,
                            //     userFacebookId: idFacebook,
                            //     userImage: img);
                            // log(jsonEncode(dto));

                            // var register = await registerService.registers(dto);
                            // log(jsonEncode(register.data));

                            // if (register.data.massage == "Register failed") {
                            //   log("Register failed");
                            // }
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

  Future uploadFile() async {
    showAlertDialog(BuildContext context) {
      // set up the button
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
                settings: const RouteSettings(arguments: null),
              ));
        },
      );

      // set up the AlertDialog
      AlertDialog alert01 = AlertDialog(
        title: const Text("ลงทะเบียนสำเร็จ !!"),
        content: const Text(""),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert01;
        },
      );
    }

    final path = 'files/${pickedFile?.path.split('/').last}';
    final file = File(pickedFile!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    log(ref.toString());

    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    log('Download Link:$urlDownload');
    img = urlDownload;
    RegisterDto dto = RegisterDto(
        userName: userName.text,
        userMail: email.text,
        userPassword: password.text,
        userFullname: fullname.text,
        userDiscription: description.text,
        userFacebookId: idFacebook,
        userImage: urlDownload);
    var register = await registerService.registers(dto);
    log(jsonEncode(register.data));
    log(jsonEncode(dto));

    avata.currentWidget;
    setState(() {
      Image.file(File(pickedFile!.path));
    });
    userName.clear();
    email.clear();
    password.clear();
    confirmpassword.clear();
    fullname.clear();
    description.clear();

    return showAlertDialog(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
          settings: const RouteSettings(arguments: null),
        ));
  }

  textField(final TextEditingController controller, String hintText,
      String labelText, String error, Icon icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
                hintText: hintText, labelText: labelText, icon: icon),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return error;
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}
