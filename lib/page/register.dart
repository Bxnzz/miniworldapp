import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniworldapp/model/DTO/loginDTO.dart';
import 'package:miniworldapp/model/DTO/registerDTO.dart';
import 'package:miniworldapp/service/Register.dart';
import 'package:provider/provider.dart';

import '../model/register.dart';
import '../service/provider/appdata.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController userFullname = TextEditingController();
  TextEditingController image = TextEditingController();
  TextEditingController discription = TextEditingController();
  

  List<RegisterDto> registerDTOs = [];
  late Future<void> loadDataMethod;
  late RegisterService registerService;
  List<Register> registers = [];
  
  //late Map<String, dynamic> userFacebook;
  
  // var _length;
  
  // var _email;
  
  // var _Fullname;
  
  
  
  
  
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย

    registerService =
        RegisterService(Dio(), baseUrl: context.read<AppData>().baseurl);

 //    userFacebook = context.read<AppData>().userFacebook;      
    // 2.2 async method
    //  loadDataMethod = addData(logins);
  // _length = userFacebook['UserName'].length;
  //  if(_length > 0){
  //    _email = userFacebook['email'];
  //    _Fullname = userFacebook['UserName'];
  //  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registers'),
      ),
      body: SingleChildScrollView(
          child: Form(
              child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: username,
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Username', hintText: 'Enter User name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Username.';
                  }
                  return null;
                },
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: email,
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Email', hintText: 'Enter Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Email';
                  }
                  return null;
                },
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: password,
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Password', hintText: 'Enter your password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: userFullname,
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Fullname-Lastname',
                    hintText: 'Enter Fullname-Lastname'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please  Fullname-Lastname';
                  }
                  return null;
                },
              )
              ),Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: discription,
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Discription',
                    hintText: 'Enter Discription'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please  Discription';
                  }
                  return null;
                },
              )),
          Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    RegisterDto dto =
                        RegisterDto(userName: username.text, userMail: email.text, userPassword: password.text, userFullname: userFullname.text,userDiscription: discription.text, userFacebookId: '', userImage: '');
                    
                  //  String _usernname = username.text;
                  //  String _email = email.text;
                  //  String _Fullname = userFullname.text;
                  //  String _
                    log(jsonEncode(dto));
                    

                   var register = await registerService.registers(dto);
                   if (register.data.massage == "Register failed"){
                          log("Register failed");                                  
                            return;
                   }
                         log(jsonEncode(register.data));
                  },
                  child: Text('Register')),
            ],
          )
        ],
      ))),
    );
  }
}
