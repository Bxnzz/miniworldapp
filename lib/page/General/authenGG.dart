import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniworldapp/page/General/const.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../service/provider/appdata.dart';
import '../../service/user.dart';
import '../../widget/loadData.dart';

class AuthenGG extends StatefulWidget {
  const AuthenGG({super.key});

  @override
  State<AuthenGG> createState() => _AuthenGGState();
}

class _AuthenGGState extends State<AuthenGG> {
  late Future<void> loadData;
  late UserService userservice;
  late List<User> users;
  String userName = '';

  @override
  void initState() {
    super.initState();
    userservice = UserService(Dio(), baseUrl: context.read<AppData>().baseurl);
    log("provider${context.read<AppData>().authenUname}");
    userName = context.read<AppData>().authenUname;
    loadData = LoadData();
  }

  Future LoadData() async {
    startLoading(context);
    try {
      log("userName is $userName");
      var usersByName = await userservice.getUserByName(userName: userName);
      users = usersByName.data;

      log("usesrByname = ${users}");
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ลงทะเบียน Google Authenicator"),
        ),
        body: FutureBuilder(
            future: loadData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column();
              } else {
                return Scaffold();
              }
            }));
  }
}
