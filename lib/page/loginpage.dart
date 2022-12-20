import 'dart:convert';
import 'dart:developer';
// import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:miniworldapp/model/DTO/loginDTO.dart';
import 'package:miniworldapp/model/login.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/dio.dart';

import '../service/login.dart';
import '../service/provider/appdata.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. กำหนดตัวแปร
  List<Login> logins = [];
  List<LoginDto> loginDTOs = [];
  late Future<void> loadDataMethod;
  late LoginService loginService;

  // 2. สร้าง initState เพื่อสร้าง object ของ service
  // และ async method ที่จะใช้กับ FutureBuilder
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย

    loginService =
        LoginService(Dio(), baseUrl: context.read<AppData>().baseurl);
    // 2.2 async method
    //  loadDataMethod = addData(logins);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      // 3. เรียก service ในรูปแบบของ FutureBuilder (หรือจะไม่ใช้ก็ได้ แค่ตัวอย่างให้ดูเฉยๆ)
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: <Widget>[
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right:15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  maxLines: 1,
                  decoration: InputDecoration(
                      labelText: 'Username', hintText: 'Enter your username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  obscureText: true,
                  maxLines: 1,
                  decoration: InputDecoration(
                      labelText: 'Password', hintText: 'Enter secure password'),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Enter the password';
                    } else
                      return null;
                  },
                ),
              ),
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        LoginDto dto = LoginDto(
                            email: "jame123@gmail.com", password: "jame12345");
                        log(jsonEncode(dto));

                        var login = await loginService.loginser(dto);
                        // if (login.response.statusCode == 200){
                          if(login.data.userId == 0){
                            log("login fail");
                            return;
                          }
                        // }
                        log(jsonEncode(login.data));

                        // try {
                        //   var login = await loginService.loginser(dto);
                        //   log(jsonEncode(login.data));
                        // } catch (ex) {
                        //   log("login fail");
                        // }

                        // loginService.loginser(dto).then((value) {
                        //   log(jsonEncode(value.data));
                        // }).onError((error, stackTrace) {
                        //   log("login fail");
                        // });
                      },
                      child: Text('LOGIN')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  // 4. Async method ที่เรียก service เมื่อได้ข้อมูลก็เอาไปเก็บไว้ที่ destinations ที่ประกาศไว้ด้านบนเป็น List
  // Future<void> addData(LoginDto login) async {
  //  var result =
  //   await http.post(Uri.parse('http://202.28.34.197:9131/user/login'),
  //   body: jsonEncode(login),
  //   headers:{'Content-Type': 'application/json; charset=UTF-8'});
  //   log(result.body);
  // }
}
