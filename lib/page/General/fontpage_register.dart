import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniworldapp/page/General/authenGG.dart';
import 'package:miniworldapp/page/General/login.dart';
import 'package:miniworldapp/service/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart';

import '../../model/DTO/registerDTO.dart';
import '../../service/Register.dart';
import '../../service/provider/appdata.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:base32/base32.dart';

import '../../widget/loadData.dart';

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
  late UserService _userService;
  bool _isHidden = false;
  bool _isHiddenConf = false;
  File? pickedFile;
  File? svgFile;
  UploadTask? uploadTask;
  bool isImage = true;

  String img = '';
  String passwordINDB = '';
  String passwordDecode = '';
  String svg = '';
  String uri = '';
  late String svgInDB = '';
  String authenUname = 'player';
  late var bytes;
  late var digest;
  late Future readSvg;
  File? _image;
  CroppedFile? croppedImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bool _isHidden = true;
    bool _isHiddenConf = true;
    registerService =
        RegisterService(Dio(), baseUrl: context.read<AppData>().baseurl);

    _userService = UserService(Dio(), baseUrl: context.read<AppData>().baseurl);
    svg = RandomAvatarString(
      DateTime.now().toIso8601String(),
      trBackground: false,
    );
  }

  String getGoogleAuthenticatorUri(String appname, String email, String key) {
    List<int> list = utf8.encode(email + key);
    String hex = HEX.encode(list);
    String secret = base32.encodeHexString(hex);
    log('secret $secret');
    uri =
        'otpauth://totp/${Uri.encodeComponent('$appname:$email?secret=$secret&issuer=$appname')}';
    //uri2 = 'otpauth://totp/$appname:$email?secret=$secret&issuer=$appname';

    return uri;
  }

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.svg');
    svgFile = await file.writeAsString(text);
    log("Text = $text");
    //  log("svgInDB = " + svgFile!.path);
  }

  Future _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    File? img = File(image.path!);
    // img = await _cropImage(imageFile: img);
    _image = img;
    croppedImage = await ImageCropper().cropImage(sourcePath: img.path);
    if (croppedImage == null) return null;

    _image = File(croppedImage!.path);

    setState(() {});
  }

  Future<dynamic> showModalBottomSheet_photo_or_camera(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: Get.width,
                child: ElevatedButton(
                    onPressed: () {
                      log("${_image}");

                      _pickImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                    child: Text("ถ่ายรูป")),
              ),
              SizedBox(
                width: Get.width,
                child: ElevatedButton(
                    onPressed: () {
                      log("${_image}");

                      setState(() {
                        _pickImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text("เลือกรูป")),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _write(svg);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('สมัครสมาชิก 1/2'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/image/NewBG.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _image != null
                        ? GestureDetector(
                            onTap: () {
                              showModalBottomSheet_photo_or_camera(context);
                            },
                            child: CircleAvatar(
                                key: avata,
                                radius:
                                    MediaQuery.of(context).size.width * 0.15,
                                backgroundImage: FileImage(_image!)),
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                child: CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: GestureDetector(
                                    child: SvgPicture.string('''$svg'''),
                                  ),
                                ),
                              ),
                              Positioned(
                                child: CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width * 0.15,
                                  backgroundColor: Get
                                      .theme.colorScheme.onBackground
                                      .withOpacity(0.5),
                                  child: IconButton(
                                      splashRadius: 100,
                                      onPressed: () {
                                        showModalBottomSheet_photo_or_camera(
                                            context);
                                        log('messadfffge');
                                      },
                                      icon: Icon(
                                        CupertinoIcons.plus_circle_fill,
                                        color: Colors.white,
                                        size: 40.0,
                                      )),
                                ),
                              )
                            ],
                          ),
                    Gap(5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ชื่อในระบบ*',
                            style: Get.textTheme.bodyLarge!.copyWith(
                                color: Get.theme.colorScheme.onBackground)),
                        SizedBox(
                          width: Get.width / 1.1,
                          child: textField(
                              userName,
                              'ชื่อในระบบ',
                              'ชื่อในระบบ...',
                              'ใส่ชื่อในระบบ',
                              Icon(Icons.account_box_sharp)),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ชื่อ-นามสกุล*',
                            style: Get.textTheme.bodyLarge!.copyWith(
                                color: Get.theme.colorScheme.onBackground)),
                        SizedBox(
                          width: Get.width / 1.1,
                          child: textField(
                              fullname,
                              'ชื่อ-นามสกุล',
                              'ชื่อ-นามสกุล',
                              'ใส่ชื่อ-นามสกุล.',
                              Icon(Icons.person_outline)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('อีเมล*',
                            style: Get.textTheme.bodyLarge!.copyWith(
                                color: Get.theme.colorScheme.onBackground)),
                        SizedBox(
                          width: Get.width / 1.1,
                          child: TextFormField(
                            style: Get.textTheme.bodyLarge,
                            controller: email,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'อีเมล...',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณาใส่อีเมล.';
                              }
                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return "ใส่อีเมลให้ถูกต้อง";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Gap(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('รหัสผ่าน*',
                            style: Get.textTheme.bodyLarge!.copyWith(
                                color: Get.theme.colorScheme.onBackground)),
                        SizedBox(
                          width: Get.width / 1.1,
                          child: TextFormField(
                            style: Get.textTheme.bodyLarge,
                            obscureText: !_isHidden,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: password,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isHidden =
                                        !_isHidden; // เมื่อกดก็เปลี่ยนค่าตรงกันข้าม
                                  });
                                },
                                icon: Icon(
                                  _isHidden // เงื่อนไขการสลับ icon
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 16,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: '********',
                              prefixIcon: Icon(Icons.password),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ใส่รหัสผ่าน.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Gap(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ยืนยันรหัสผ่าน*',
                            style: Get.textTheme.bodyLarge!.copyWith(
                                color: Get.theme.colorScheme.onBackground)),
                        SizedBox(
                          width: Get.width / 1.1,
                          child: TextFormField(
                            obscureText: !_isHiddenConf,
                            style: Get.textTheme.bodyLarge,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: confirmpassword,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: '********',
                              prefixIcon: Icon(Icons.password),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isHiddenConf =
                                        !_isHiddenConf; // เมื่อกดก็เปลี่ยนค่าตรงกันข้าม
                                  });
                                },
                                icon: Icon(
                                  _isHiddenConf // เงื่อนไขการสลับ icon
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 16,
                                ),
                              ),
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
                        ),
                      ],
                    ),
                    Gap(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('คำอธิบายตัวเอง',
                            style: Get.textTheme.bodyLarge!.copyWith(
                                color: Get.theme.colorScheme.onBackground)),
                        SizedBox(
                          width: Get.width / 1.1,
                          child: TextFormField(
                            controller: description,
                            style: Get.textTheme.bodyLarge,
                            decoration: InputDecoration(
                              hintText: 'Ex.สวัสดีB1เรามาเล่นเกมด้วยกันนะ...',
                              contentPadding: EdgeInsets.all(15),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.multiline,
                            minLines: 3,
                            maxLines: 4,
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'แนะนำตัวคุณหน่อย.';
                            //   }

                            //   return null;
                            // },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SizedBox(
                        width: 250,
                        child: ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Colors.amberAccent),
                            ),
                            onPressed: () async {
                              if (await _formKey.currentState!.validate()) {
                                if (_image != null) {
                                  uploadFile();
                                  log("password =  $digest");
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('กรุณาเลือกรูปภาพ!!! !!')),
                                  );
                                }

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
                            child: Text('ลงทะเบียน',
                                style: Get.textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Get.theme.colorScheme.background))),
                      ),
                    ),
                    // CircleAvatar(
                    //     radius: MediaQuery.of(context).size.width * 0.15,
                    //     child: svgFile != null
                    //         ? GestureDetector(
                    //             child: SvgPicture.file(
                    //             File(svgFile!.path),
                    //           ))
                    //         : widget),

                    ///   TEST authen GG//
                    // ElevatedButton(
                    //     onPressed: () {
                    //       context.read<AppData>().authenUPass =
                    //           '678e82d907d3e6e71f81d5cf3ddacc3671dc618c38a1b7a9f9393a83d025b296';
                    //       context.read<AppData>().authenUMail =
                    //           'test01@gmail.com';
                    //       getGoogleAuthenticatorUri(
                    //           "mnrace",
                    //           'test01@gmail.com',
                    //           '678e82d907d3e6e71f81d5cf3ddacc3671dc618c38a1b7a9f9393a83d025b296');
                    //       context.read<AppData>().authenUri = uri;
                    //       Get.off(() => AuthenGG());
                    //     },
                    //     child: Text("authen"))
                  ],
                ),
              ),
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
    startLoading(context);
    showAlertDialog(BuildContext context) {
      // set up the button
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () {
          context.read<AppData>().authenUPass = digest.toString();
          context.read<AppData>().authenUMail = email.text;
          getGoogleAuthenticatorUri("mnrace", email.text, digest.toString());
          context.read<AppData>().authenUri = uri;
          Get.off(() => AuthenGG());

          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const Login(),
          //       settings: const RouteSettings(arguments: null),
          //     ));
        },
      );

      // set up the AlertDialog
      AlertDialog alert01 = AlertDialog(
          title: const Text("ลงทะเบียนสำเร็จ !!"), content: okButton);

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert01;
        },
      );
    }

    log("before upload");

    ///upload SVG
    // if (pickedFile == null) {
    //   log("Pickfile Null ");
    //   passwordINDB = password.text;
    //   bytes = utf8.encode(passwordINDB); // data being hashed

    //   // _write(svgInDB);

    //   // readSvg;
    //   //_read();

    //   digest = sha256.convert(bytes);

    //   final path = 'files/${svgFile!.path.split('/').last}';
    //   final file = File(svgFile!.path);
    //   final ref = FirebaseStorage.instance.ref().child(path);
    //   log(ref.toString());

    //   setState(() {
    //     uploadTask = ref.putFile(file);
    //   });
    //   final snapshot = await uploadTask!.whenComplete(() {});

    //   final urlDownload = await snapshot.ref.getDownloadURL();
    //   log('Download Link:$urlDownload');

    //   // log("encode =" + EncryptData.encryptAES("abc"));

    //   // log("decode =" + EncryptData.decryptAES(" 21dd8abc6894bdf6946f2fb8045f4890b74951d7a62b7068cf61eeed4d29d68f"));
    //   RegisterDto dto = RegisterDto(
    //       userName: userName.text,
    //       userMail: email.text,
    //       userPassword: digest.toString(),
    //       userFullname: fullname.text,
    //       userDiscription: description.text,
    //       userFacebookId: idFacebook,
    //       userImage: urlDownload);
    //   var register = await registerService.registers(dto);

    //   var userRegis = await _userService.getUserAll();
    //   if (register.data.massage == "Register failed") {
    //     log("already email $email");
    //     log(jsonEncode(register.data));

    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('อีเมลนี้เคยลงทะเบียนแล้ว!!')),
    //     );
    //     stopLoading();
    //   } else {
    //     // avata.currentWidget;
    //     // setState(() {
    //     //   Image.file(File(pickedFile!.path));
    //     // });

    //     userName.clear();
    //     email.clear();
    //     password.clear();
    //     confirmpassword.clear();
    //     fullname.clear();
    //     description.clear();
    //     stopLoading();
    //     return showAlertDialog(context);
    //   }
    // }

    //upload image
    // else {
    if (_image != null) {
      bytes = utf8.encode(password.text); // data being hashed
      digest = sha256.convert(bytes);
//passwordINDB = password.text;
      final path = 'files/${_image?.path.split('/').last}';
      final file = File(_image!.path);
      final ref = FirebaseStorage.instance.ref().child(path);
      log(ref.toString());

      setState(() {
        uploadTask = ref.putFile(file);
      });
      final snapshot = await uploadTask!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      log('Download Link:$urlDownload');
      img = urlDownload;

      log("Digest as bytes: ${digest.bytes}");
      log("Digest as hex string: $digest");
      RegisterDto dto = RegisterDto(
          userName: userName.text,
          userMail: email.text,
          userPassword: digest.toString(),
          userFullname: fullname.text,
          userDiscription: description.text,
          userFacebookId: idFacebook,
          userImage: urlDownload);
      var register = await registerService.registers(dto);

      log("register.data.massage  ${register.data.massage}");
      if (register.data.massage == "Register failed") {
        log("already email $email");
        log(jsonEncode(register.data));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลงทะเบียนล้มเหลว !!')),
        );
        stopLoading();
      } else {
        avata.currentWidget;
        setState(() {
          Image.file(File(_image!.path));
        });

        userName.clear();
        // email.clear();
        //  password.clear();
        confirmpassword.clear();
        fullname.clear();
        description.clear();
        stopLoading();
        return showAlertDialog(context);
      }
    }
  }

  // }

  textField(final TextEditingController controller, String hintText,
      String labelText, String error, Icon icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          TextFormField(
            style: Get.textTheme.bodyLarge,
            controller: controller,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: hintText,
                prefixIcon: icon),
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
