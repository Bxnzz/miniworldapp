import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hex/hex.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:miniworldapp/model/DTO/passwordChengeDTO.dart';
import 'package:miniworldapp/model/DTO/registerDTO.dart';
import 'package:miniworldapp/model/DTO/userDTO.dart';
import 'package:miniworldapp/page/General/Home.dart';
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/General/login.dart';
import 'package:miniworldapp/service/provider/appdata.dart';
import 'package:miniworldapp/service/user.dart';
import 'package:otp/otp.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:base32/base32.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/result/raceResult.dart';
import '../../model/user.dart';
import '../../widget/loadData.dart';

class Profile_edit extends StatefulWidget {
  const Profile_edit({super.key});

  @override
  State<Profile_edit> createState() => _Profile_editState();
}

class _Profile_editState extends State<Profile_edit> {
  late Future<void> loadDataMethod;
  late UserService userservice;
  late List<User> users;
  late RaceResult userResult;

  TextEditingController userName = TextEditingController();
  TextEditingController userFullName = TextEditingController();
  TextEditingController userDis = TextEditingController();
  TextEditingController userMail = TextEditingController();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmnewPassword = TextEditingController();
  TextEditingController pin = TextEditingController();
  final avata = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  File? _image;
  File? pickedFile;
  UploadTask? uploadTask;
  int userID = 0;
  String userimg = '';
  String img = '';
  String uri = '';
  String uri2 = '';
  String value = '';
  CroppedFile? croppedImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userservice = UserService(Dio(), baseUrl: context.read<AppData>().baseurl);
    userID = context.read<AppData>().idUser;

    log("userID = ${userID}");
    loadDataMethod = loadData();
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

  Future<File?> _cropImage({required File imageFile}) async {
    croppedImage = await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage!.path);
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
                builder: (context) => const Home(),
                settings: const RouteSettings(arguments: null),
              ));
        },
      );

      // set up the AlertDialog
      AlertDialog alert01 = AlertDialog(
        title: const Text("แก้ไขโปรไฟล์สำเร็จ !!"),
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

    final path = 'files/${_image?.path.split('/').last}';
    final file = File(_image!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    log(ref.toString());

    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {});

    String urlDownload = await snapshot.ref.getDownloadURL();
    log('Download Link:$urlDownload');
    img = urlDownload;
    if (urlDownload == null) {
      urlDownload = '';
    }
    avata.currentWidget;
    setState(() {
      loadDataMethod = loadData();
      // Image.file(File(_image!.path));
    });
    UserDto user = UserDto(
        userName: userName.text,
        userMail: userMail.text,
        userFullname: userFullName.text,
        userImage: urlDownload,
        userDiscription: userDis.text,
        onesingnalId: '');
    var user1 = await userservice.updateUsers(
      user,
      userID.toString(),
    );
  }

  Future<void> loadData() async {
    startLoading(context);

    try {
      log("${userID} asdfasdf");
      var user = await userservice.getUserByID(userID: userID);
      users = user.data;

      userName.text = user.data.last.userName;
      userFullName.text = users.first.userFullname;
      userDis.text = users.first.userDiscription;
      userMail.text = users.first.userMail;
      oldPassword.text = users.first.userPassword;
      userimg = users.first.userImage;
      log("user name ${userName.text}");
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

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
          if (await _formKey.currentState!.validate()) {
            passwordRenew(context);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'ใส่Pin.';
          }
          if (value != getTotp(userMail.text + users.first.userPassword)) {
            return 'ใส่ PIN ไม่ถูกต้อง.';
          }

          return null;
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "แก้ไขโปรไฟล์",
          style: textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.purple,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/image/BGall.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
            future: loadDataMethod,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                    left: 20,
                                    right: 20),
                                child: _editFrom(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  // ElevatedButton editBTN(BuildContext context) {
  //   return ElevatedButton(
  //       onPressed: () {
  //         //EditProfile
  //         showModalBottomSheet(
  //             enableDrag: false,
  //             context: context,
  //             isScrollControlled: true,
  //             builder: (context) {
  //               return Column(
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       IconButton(
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                           },
  //                           icon: FaIcon(FontAwesomeIcons.xmark)),
  //                       IconButton(
  //                           onPressed: () async {
  //                             await uploadFile();

  //                             Navigator.of(context).pop();
  //                           },
  //                           icon: FaIcon(FontAwesomeIcons.check))
  //                     ],
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(
  //                         bottom: MediaQuery.of(context).viewInsets.bottom),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(10.0),
  //                       child: _editFrom(context),
  //                     ),
  //                   ),
  //                 ],
  //               );
  //             });
  //       },
  //       child: Text("แก้ไขโปรไฟล์"));
  // }

  Column _editFrom(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        users.first.userImage.contains("svg")
            ? GestureDetector(
                onTap: () {
                  showModalBottomSheet_photo_or_camera(context);
                },
                child: _image != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(_image!.path)),
                      )
                    : SvgPicture.network("${userimg}"))
            : GestureDetector(
                onTap: () {
                  //Select gallery or camera
                  showModalBottomSheet_photo_or_camera(context);
                },
                child: _image == null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userimg),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(_image!.path)),
                      )),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ชื่อในระบบ*',
                style: Get.textTheme.bodyLarge!
                    .copyWith(color: Get.theme.colorScheme.onBackground)),
            SizedBox(
              width: Get.width / 1.1,
              child: TextFormField(
                style: Get.textTheme.bodyLarge,
                controller: userName,
                decoration: const InputDecoration(
                  hintText: 'ชื่อในระบบ...',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('อีเมล*',
                style: Get.textTheme.bodyLarge!
                    .copyWith(color: Get.theme.colorScheme.onBackground)),
            TextFormField(
              enabled: false,
              controller: userMail,
              style: Get.textTheme.bodyLarge!,
              decoration: const InputDecoration(
                hintText: "อีเมล",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ],
        ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ชื่อ-นามสกุล*',
                style: Get.textTheme.bodyLarge!
                    .copyWith(color: Get.theme.colorScheme.onBackground)),
            TextFormField(
              style: Get.textTheme.bodyLarge!,
              controller: userFullName,
              decoration: const InputDecoration(
                hintText: " ชื่อ-นามสกุล",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ],
        ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('คำอธิบายตัวเอง',
                style: Get.textTheme.bodyLarge!
                    .copyWith(color: Get.theme.colorScheme.onBackground)),
            TextFormField(
              controller: userDis,
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
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () async {
                  getGoogleAuthenticatorUri(
                      "mnrace", userMail.text, users.first.userPassword);
                  log(getTotp(userMail.text + users.first.userPassword));
                  regisOTP(context);
                },
                child: Text("ลงทะเบียน OTP")),
            TextButton(
                onPressed: () async {
                  // getGoogleAuthenticatorUri(
                  //     "mnrace", userMail.text, users.first.userPassword);
                  // log(getTotp(userMail.text + users.first.userPassword));
                  editpass(context);
                  //   passwordRenew(context);
                },
                child: Text("เปลี่ยนรหัสผ่าน")),
          ],
        ),
        SizedBox(
          width: 300,
          child: FilledButton(
              // style: const ButtonStyle(
              //   backgroundColor:
              //       MaterialStatePropertyAll<Color>(Colors.amberAccent),
              // ),
              onPressed: () async {
                await uploadFile();

                Navigator.of(context).pop();
              },
              child: Text("แก้ไขโปรไฟล์",
                  style: Get.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.background))),
        ),
      ],
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

  Future<dynamic> editpass(BuildContext context) {
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
                height: Get.height / 2,
                child: Column(
                  children: [
                    Gap(20),
                    Text(
                      "ใส่รหัส PIN แอบพลิเคชั่น\n\"Authenicator \"",
                      textAlign: TextAlign.center,
                      style: Get.theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                        fontSize: 20,
                      ),
                    ),
                    // Gap(20),
                    // Image.network(
                    //     'https://www.google.com/chart?chs=200x200&chld=M|0&cht=qr&chl=$uri'),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 70),
                    //   child: TextButton(
                    //       onPressed: () async {
                    //         AppInfo app = await InstalledApps.getAppInfo(
                    //             'com.google.android.apps.authenticator2');
                    //         if (app.name!.isEmpty) {
                    //           log('Not installed. Show QR');
                    //         } else {
                    //           log(app.name!);
                    //           await launchUrl(Uri.parse(uri2));
                    //         }
                    //         //  await launchUrl(Uri.parse(uri2));
                    //       },
                    //       child: Text("เปิด Authenicator")),
                    // ),

                    Gap(20),
                    buildPinPut(),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            pin.clear();
                          });
                        },
                        child: Text("ล้างค่าPIN")),
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

  Future<dynamic> passwordRenew(BuildContext context) {
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
                            Get.to(() => Login());
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

  Future<void> chengePassword() async {
    PasswordChengeDto passChenge =
        PasswordChengeDto(userPassword: newPassword.text);

    var userChangePass = await userservice.chengePassword(
      passChenge,
      userID.toString(),
    );
    userResult = userChangePass.data;
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
}
