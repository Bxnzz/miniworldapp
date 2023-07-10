import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../service/provider/appdata.dart';
import 'chat_room.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key, required this.idRace, required this.idUser});
  late int idUser;
  late int idRace;
  late String userName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController roomCtl = TextEditingController();
  TextEditingController userIdCtl = TextEditingController();
  TextEditingController firstNameCtl = TextEditingController();

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  void initState() {
    // TODO: implement initState
    roomCtl.text = widget.idRace.toString();
    userIdCtl.text = widget.idUser.toString();
    firstNameCtl.text = 'เอ็ม';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatroom'),
      ),
      body: FutureBuilder(
          future: firebase, // Connect to Firebase App
          builder: (context, snapShot) {
            // If connection success => Firebase instance will be created
            if (snapShot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          const Text('Room ID'),
                          TextField(
                            controller: roomCtl,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('User ID'),
                          TextField(
                            controller: userIdCtl,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('Firstname'),
                          TextField(
                            controller: firstNameCtl,
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                if (roomCtl.text.isNotEmpty &&
                                    userIdCtl.text.isNotEmpty &&
                                    firstNameCtl.text.isNotEmpty) {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => ChatRoomPage(
                                  //         roomID: widget.idRace.toString(),
                                  //         userID: widget.idUser.toString(),
                                  //         firstName: firstNameCtl.text,
                                  //       ),
                                  //     ));
                                }
                              },
                              child: const Text('Enter Chatroom'))
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const Text('Connecting to Firebase...'),
                  ],
                ),
              );
            }
          }),
    );
  }
}
