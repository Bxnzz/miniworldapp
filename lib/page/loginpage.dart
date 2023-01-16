import 'dart:convert';
import 'dart:developer';
// import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // 2. สร้าง initState เพื่อสร้าง object ของ service
  // และ async method ที่จะใช้กับ FutureBuilder
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
  
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: <Widget>[
              Padding(

                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: email,
                  maxLines: 1,
                  decoration: const InputDecoration(
                      labelText: 'E-mail', hintText: 'Enter your Email'),                      
                  validator: (value) {                   
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Email';
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
                  controller: password,
                  obscureText: true,
                  maxLines: 1,
                  decoration: const InputDecoration(
                      labelText: 'Password', hintText: 'Enter secure password'),               
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Enter the password';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        LoginDto dto = LoginDto(
                            email: email.text, password: password.text);
                        log(jsonEncode(dto));

                        var login = await loginService.loginser(dto);
                     
                          if(login.data.userId == 0){
                            log("login fail");
                            return;
                          }
                       
                        log(jsonEncode(login.data));
                        
                    
                      },
                      child: const Text('LOGIN')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
 
}



// import 'package:flutter/material.dart';
// //import 'package:simple_animations/simple_animations.dart';

// /**
//  * Author: Ambika Dulal
//  * profile: https://github.com/ambikadulal
//  * images:pixabay.com
//   */

// class LoginPageThirdteen extends StatelessWidget {
//   static final String path = "lib/src/pages/login/login13.dart";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Container(
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   height: 400,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         //topLeft: Radius.circular(60),
//                         // topRight: Radius.circular(60),
//                         //bottomLeft: Radius.circular(20),
//                         bottomRight: Radius.circular(300),
//                       ),
//                       image: DecorationImage(
//                           image: NetworkImage(
//                               'https://cdn.pixabay.com/photo/2015/03/30/12/37/jellyfish-698521__340.jpg'),
//                           fit: BoxFit.fill)),
//                   child: Stack(
//                     children: <Widget>[
//                       Positioned(
//                         left: 30,
//                         width: 80,
//                         height: 200,
//                         child: Container(
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   image: NetworkImage(
//                                       'https://cdn.pixabay.com/photo/2019/12/24/08/54/flying-dandelions-4716287__340.png'))),
//                         ),
//                       ),
//                       Positioned(
//                         left: 140,
//                         width: 80,
//                         height: 150,
//                         child: Container(
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   image: NetworkImage(
//                                       'https://cdn.pixabay.com/photo/2016/08/25/07/30/red-1618916__340.png'))),
//                         ),
//                       ),
//                       Positioned(
//                         right: 40,
//                         top: 40,
//                         width: 80,
//                         height: 150,
//                         child: Container(
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   image: NetworkImage(
//                                       'https://cdn.pixabay.com/photo/2019/10/22/07/52/dandelions-4567966__340.png'))),
//                         ),
//                       ),
//                       Positioned(
//                         child: Container(
//                           margin: EdgeInsets.only(top: 50),
//                           child: Center(
//                             child: Text(
//                               "Login",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 40,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(30.0),
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         padding: EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: [
//                               BoxShadow(
//                                   color: Color.fromRGBO(143, 148, 251, .2),
//                                   blurRadius: 20.0,
//                                   offset: Offset(0, 10))
//                             ]),
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               padding: EdgeInsets.all(8.0),
//                               decoration: BoxDecoration(
//                                   border: Border(
//                                       bottom:
//                                           BorderSide(color: Colors.grey[100]!))),
//                               child: TextField(
//                                 decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     hintText: "Email or Phone number",
//                                     hintStyle:
//                                         TextStyle(color: Colors.grey[400])),
//                               ),
//                             ),
//                             Container(
//                               padding: EdgeInsets.all(8.0),
//                               child: TextField(
//                                 decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     hintText: "Password",
//                                     hintStyle:
//                                         TextStyle(color: Colors.grey[400])),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Container(
//                         height: 50,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             gradient: LinearGradient(colors: [
//                               Color.fromRGBO(143, 148, 251, 1),
//                               Color.fromRGBO(143, 148, 251, .6),
//                             ])),
//                         child: Center(
//                           child: Text(
//                             "Login",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 70,
//                       ),
//                       Text(
//                         "Forgot Password?",
//                         style:
//                             TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }

// class FadeAnimation extends StatelessWidget {
//   final double delay;
//   final Widget child;

//   FadeAnimation(this.delay, this.child);

//   @override
//   Widget build(BuildContext context) {
//     final tween = MovieTween()
//       ..tween(
//         "opacity",
//         Tween(begin: 0.0, end: 1.0),
//         duration: Duration(milliseconds: 500),
//       ).thenTween(
//         "translateY",
//         Tween(begin: -30.0, end: 0.0),
//         duration: Duration(milliseconds: 500),
//         curve: Curves.easeOut,
//       );

//     return PlayAnimationBuilder<Movie>(
//       delay: Duration(milliseconds: (500 * delay).round()),
//       duration: tween.duration,
//       tween: tween,
//       child: child,
//       builder: (context, value, child) => Opacity(
//         opacity: value.get('opacity'),
//         child: Transform.translate(
//             offset: Offset(0, value.get("translateY")), child: child),
//       ),
//     );
//   }
// }