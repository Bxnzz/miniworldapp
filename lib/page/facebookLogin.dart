
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


class FacebookLoginPage extends StatefulWidget {
  const FacebookLoginPage({super.key});

  @override
  State<FacebookLoginPage> createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends  State<FacebookLoginPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Facebook Login') ,),
        body: Column(children: [
        ElevatedButton(
            onPressed: () async {
            final LoginResult result = await FacebookAuth.instance.login();
             // by default we request the email and the public profile           
            // or FacebookAuth.i.login()
            if (result.status == LoginStatus.success) {
            // you are logged
            final AccessToken accessToken = result.accessToken!;
            log(accessToken.token);  
            final userData = await FacebookAuth.instance.getUserData();
            log(userData['email']);
          }else{
            print(result.status);
            print(result.message);
          }
            },
            child: Text('FacebookLogin')), 
            
        ])
    );
  }
}