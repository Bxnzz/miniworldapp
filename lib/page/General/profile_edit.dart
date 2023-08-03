import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniworldapp/model/DTO/registerDTO.dart';
import 'package:miniworldapp/model/DTO/userDTO.dart';
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/service/provider/appdata.dart';
import 'package:miniworldapp/service/user.dart';
import 'package:provider/provider.dart';

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

  final avata = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  File? _image;
  File? pickedFile;
  UploadTask? uploadTask;
  int userID = 0;
  String img = '';
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

    log(img.path);
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
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
                builder: (context) => const HomeAll(),
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

    avata.currentWidget;
    setState(() {
      loadDataMethod = loadData();
      Image.file(File(_image!.path));
    });
    UserDto user = UserDto(
        userName: userName.text,
        userMail: '',
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
      var user = await userservice.getUserByID(userID);
      users = user.data;
      userName.text = user.data.last.userName;
      userFullName.text = users.first.userFullname;
      userDis.text = users.first.userDiscription;
      userMail.text = users.first.userMail;

      log("user name ${userName.text}");
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.circleChevronLeft,
                          color: Colors.yellow,
                          size: 35,
                        ),
                      ),
                      Text(
                        "โปรไฟล์",
                        style: textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Card(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: CircleAvatar(
                                            radius: 100,
                                            backgroundImage: NetworkImage(
                                              "${users.first.userImage}",
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                      "${users.first.userImage}",
                                    )),
                              ),
                            ),
                            Text("${userName.text}"),
                            Text("${users.first.userFullname}"),
                            Text("${users.first.userDiscription}"),
                            SizedBox(
                              width: Get.width - 50,
                              child: editBTN(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }

  ElevatedButton editBTN(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          //EditProfile
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: FaIcon(FontAwesomeIcons.xmark)),
                        IconButton(
                            onPressed: () async {
                              await uploadFile();

                              Navigator.of(context).pop();
                            },
                            icon: FaIcon(FontAwesomeIcons.check))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        height: Get.height / 2 - 40,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: showModalBottomSheetEdit(context),
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        child: Text("แก้ไขโปรไฟล์"));
  }

  Column showModalBottomSheetEdit(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
            onTap: () {
              //Select gallery or camera
              showModalBottomSheet_photo_or_camera(context);
            },
            child: _image == null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage("${users.first.userImage}"),
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(_image!),
                  )),
        TextFormField(
          controller: userName,
          decoration: InputDecoration(label: Text("ชื่อในระบบ")),
        ),
        TextFormField(
          controller: userMail,
          decoration: InputDecoration(label: Text("อีเมล")),
        ),
        TextFormField(
          controller: userFullName,
          decoration: InputDecoration(label: Text(" ชื่อ-นามสกุล")),
        ),
        TextFormField(
          controller: userDis,
          decoration: InputDecoration(label: Text("คำอธิบายตัวเอง")),
        ),
        SizedBox(
          width: 150,
          child: ElevatedButton(
              onPressed: () async {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: oldPassword,
                              decoration:
                                  InputDecoration(label: Text("รหัสผ่านเดิม")),
                              validator: (value) {
                                if (value != users.first.userPassword) {
                                  return 'ใส่รหัสผ่านเดิมไม่ถูกต้อง.';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: newPassword,
                              decoration:
                                  InputDecoration(label: Text("รหัสผ่านใหม่")),
                            ),
                            TextFormField(
                              controller: confirmnewPassword,
                              decoration: InputDecoration(
                                  label: Text("ยืนยันรหัสผ่าน")),
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
                                  if (await _formKey.currentState!.validate()) {
                                    setState(() {
                                      chengePassword();
                                    });
                                  }
                                },
                                child: Text("เปลี่ยนรหัสผ่าน"))
                          ],
                        ),
                      );
                    });
              },
              child: Text("เปลี่ยนรหัสผ่าน")),
        )
      ],
    );
  }

  Future<void> chengePassword() async {
    RegisterDto user = RegisterDto(
        userName: '',
        userMail: '',
        userPassword: newPassword.text,
        userFullname: '',
        userImage: '',
        userDiscription: '',
        userFacebookId: '');

    var userChangePass = await userservice.chengePassword(
      user,
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
