import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniworldapp/model/DTO/loginDTO.dart';
import 'package:miniworldapp/service/Register.dart';

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
  TextEditingController userDiscription = TextEditingController();
  TextEditingController userFacebookID = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                    return 'Please enter Username';
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
              )),
          Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    LoginDto dto =
                        LoginDto(email: email.text, password: password.text);
                    log(jsonEncode(dto));

                    //           var login = await RegisterService.register(dto);
                    // if (login.response.statusCode == 200){

                    // }
                    //       log(jsonEncode(login.data));
                  },
                  child: Text('Register')),
            ],
          )
        ],
      ))),
    );
  }
}
