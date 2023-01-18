
// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:miniworldapp/page/Newhome.dart';
import 'package:miniworldapp/page/register.dart';
import 'package:miniworldapp/service/provider/appdata.dart';
import 'package:provider/provider.dart';

import '../model/DTO/loginFBDTO.dart';
import 'loginpage.dart';


class FacebookLoginPage extends StatefulWidget {
  const FacebookLoginPage({super.key});

  @override
  State<FacebookLoginPage> createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends  State<FacebookLoginPage>{
  late String idFB;

  
   
  //late String fblog;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Login Facebook') ,),
        body: Column(children: [
       
        ElevatedButton(
            onPressed: () async {
            final LoginResult result = await FacebookAuth.instance.login();
        
            if (result.status == LoginStatus.success) {
           
            final AccessToken accessToken = result.accessToken!;
            log(accessToken.token);  
            final userData = await FacebookAuth.instance.getUserData();
            log(userData.toString());
                       
            context.read<AppData>().userFacebook = userData; 
            idFB = userData['id']; 
            LoginFbdto loginFb = LoginFbdto(facebookid: idFB);
            log(loginFb.toString());
            
             log(idFB.toString());         
          }else{
            log(result.status.toString());
            log(result.message.toString());
           
          }
          var fblog = int.parse(idFB);
          
          if(fblog > 0){
            Navigator.push(context,
                 MaterialPageRoute(builder: (context) => const NewHome()));
          }else{
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RegisterPage()));
          }   
      
            },
            child: const Text('Facebook Login')), 
            
        ])
    );
  }
}