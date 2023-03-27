import 'package:flutter/material.dart';

class CeateTeam extends StatefulWidget {
  const CeateTeam({super.key});

  @override
  State<CeateTeam> createState() => _CeateTeamState();
}

class _CeateTeamState extends State<CeateTeam> {
  @override
  Widget build(BuildContext context) {
    return const Fromcreate();
  }
}

class Fromcreate extends StatefulWidget {
  const Fromcreate({super.key});

  @override
  State<Fromcreate> createState() => _FromcreateState();
}

class _FromcreateState extends State<Fromcreate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      body: Center(
          child: Expanded(
        child: Stack(
            alignment: AlignmentDirectional.topCenter,
            clipBehavior: Clip.none,
            children: [
              Expanded(
                child: Card(
                  margin: const EdgeInsets.fromLTRB(32, 100, 32, 32),
                  color: Colors.purple.shade50,
                  
                  child: Column(
                    children: const <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(32, 50, 32, 32),
                          child: TextField(
                            decoration: InputDecoration(
                              
                              hintText: 'ชื่อทีม',
                            ),
                          )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(32, 20, 32, 32),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'ชื่อสมาชิกคนที่ 1',
                              ),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(32, 20, 32, 32),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'ชื่อสมาชิกคนที่ 2',
                              ),),
                          ),
                        
                    ],
                  ),
                ),
              ),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: Colors.purple.shade50, width: 3),
                      shape: BoxShape.rectangle,
                    ),
                    child: const Text('ลงทะเบียนเข้าร่วม'),
                  ),
                ),
              )
            ]),
      )),
    );
  }
}
