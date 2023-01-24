// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
 
// import '../utils/user_provider.dart';
// import '../models/user_model.dart';
 
// import 'login.dart';
   
// class Profile extends StatefulWidget {
//     static const routeName = '/profile';
  
//     const Profile({Key? key}) : super(key: key);
   
//     @override
//     State<StatefulWidget> createState() {
//         return _ProfileState();
//     }
// }
   
// class _ProfileState extends State<Profile> {
//     late bool _loginSuccess;  // กำหดตัวแปรสถานะการล็อกอิน
//     // ส่วนของตัวแปรข้อมูลพื้นฐาน
//     User? _user;
//     int _id = 0;
//     String _email = '';
//     String _token = '';
//     // ส่วนของตัวแปรสำหรับข้อมูลที่ดึงเพิ่มเติม
//     String _createdate = '';
 
 
//     @override
//     void initState() {
//       super.initState();
//       loadSettings(); // เรียกใช้งานตั้งค่าเมื่อเริ่มต้นเป็นฟังก์ชั่น ให้รองรับ async
//     }
 
//     // ตั้งค่าเริ่มต้น
//     void loadSettings() async {
//       // ใช้งาน provider
//       UserProvider userProvider = context.read<UserProvider>();
//       _loginSuccess = await userProvider.getLoginStatus(); // ถึงสถานะการล็อกอิน ถ้ามี
//       if(_loginSuccess){ // ถ้าล็อกอินอยู่
//         fetchUser(); // ดึงข้อมูลของผู้ใช้ ถ้าล็อกอินอยู่
//       }
//     }   
 
//     // ฟังก์ชั่นสำหรับดึงข้อมูลผู้ใช้
//     void fetchUser() async {
//       // ใช้งาน provider
//       UserProvider userProvider = context.read<UserProvider>();
//       setState(() {
//         _loginSuccess = true;
//       });           
//       // ดึงข้อมูลทั่วไปของผู้ใช้ 
//       _user = await userProvider.getUser();
//       _email = _user!.email;
//       _id = _user!.id;
//       _token = _user!.token ?? '';
//       // ดึงข้อมูลเพิ่มเติมในฐานข้อมูลบน server
//       Map<String, dynamic> _userExt = await userProvider.get(_token,_id);
//       _createdate = _userExt['user_cratedate'];
//     }
 
//     @override
//     void dispose() {
//       super.dispose();
//     }
 
//     @override
//     Widget build(BuildContext context) {
//       // ใช้งาน provider
//         UserProvider userProvider = context.read<UserProvider>();
//         return Scaffold(
//             appBar: AppBar(
//                 title: Text('Profile'),
//             ),
//             body: FutureBuilder<bool>( 
//               future: userProvider.getLoginStatus(), // ข้อมูล Future
//               builder: (context, snapshot) { 
//                 if (snapshot.hasData) { 
//                   return Center(
//                     child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                             Text('Profile Screen'),
//                             Visibility( // ส่วนที่แสดงกรณีล็อกอินแล้ว
//                               visible: _loginSuccess, // ใช้สถานะการล็อกอินกำหนดกรแสดง
//                               child: Column(
//                                 children: [
//                                   FlutterLogo(size: 100,),
//                                   Text('Welcome member'),
//                                   Text(_email), // แสดงอีเมล
//                                   ElevatedButton(
//                                     onPressed: () async { // เมื่อล็อกเอาท์
//                                       // ทำการออกจากระบบ 
//                                       await userProvider.logout();
//                                       setState(() {
//                                         _loginSuccess = false;
//                                       });                      
//                                     }, 
//                                     child: Text('Logout'),
//                                   ),        
//                                 ],
//                               ),
//                             ),
//                             Visibility( // ส่วนที่แสดงกรณียังไม่ได้ล็อกอิน
//                               visible: !_loginSuccess, // ใช้สถานะตรงข้ามการล็อกอินกำหนดกรแสดง
//                               child: ElevatedButton(
//                                 onPressed: () async {
//                                   // กำหดให้รอค่า หลังจากเปิดไปหน้า lgoin
//                                   final result = await Navigator.push(
//                                     context, 
//                                     MaterialPageRoute(builder: (context) => Login(),
//                                       settings: RouteSettings(
//                                         arguments: null
//                                       ),
//                                     ),
//                                   );    
//                                   // ถ้ามีการปิดหน้มที่เปิด และส่งค่ากลับมาเป็น true
//                                   if (result == true) {
//                                     // ทำคำสั่งดึงข้อมูลผู้ใช้ เมื่อล็อกอินผ่าน
//                                     fetchUser();   
//                                   }
                                               
//                                 }, 
//                                 child: Text('Go to Login'),
//                               ),
//                             ),
//                         ],
//                     )
//                 );
//                 } else if (snapshot.hasError) { // ถ้ามี error
//                   return Text('${snapshot.error}');
//                 }
//                 return const CircularProgressIndicator();
//               },
//             ),  
//         );
//     }
// }
 
//     ไฟล์ login.dart
 
// 1
// 2
// 3
// 4
// 5
// 6
// 7
// 8
// 9
// 10
// 11
// 12
// 13
// 14
// 15
// 16
// 17
// 18
// 19
// 20
// 21
// 22
// 23
// 24
// 25
// 26
// 27
// 28
// 29
// 30
// 31
// 32
// 33
// 34
// 35
// 36
// 37
// 38
// 39
// 40
// 41
// 42
// 43
// 44
// 45
// 46
// 47
// 48
// 49
// 50
// 51
// 52
// 53
// 54
// 55
// 56
// 57
// 58
// 59
// 60
// 61
// 62
// 63
// 64
// 65
// 66
// 67
// 68
// 69
// 70
// 71
// 72
// 73
// 74
// 75
// 76
// 77
// 78
// 79
// 80
// 81
// 82
// 83
// 84
// 85
// 86
// 87
// 88
// 89
// 90
// 91
// 92
// 93
// 94
// 95
// 96
// 97
// 98
// 99
// 100
// 101
// 102
// 103
// 104
// 105
// 106
// 107
// 108
// 109
// 110
// 111
// 112
// 113
// 114
// 115
// 116
// 117
// 118
// 119
// 120
// 121
// 122
// 123
// 124
// 125
// 126
// 127
// 128
// 129
// 130
// 131
// 132
// 133
// 134
// 135
// 136
// 137
// 138
// 139
// 140
// 141
// 142
// 143
// 144
// 145
// 146
// 147
// 148
// 149
// 150
// 151
// 152
// 153
// 154
// 155
// 156
// 157
// 158
// 159
// 160
// 161
// 162
// 163
// 164
// 165
// 166
// 167
// 168
// 169
// 170
// 171
// 172
// 173
// 174
// 175
// 176
// 177
// 178
// 179
// 180
// 181
// 182
// 183
// 184
// 185
// 186
// 187
// 188
// 189
// 190
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
 
// import '../utils/user_provider.dart';
// import 'register.dart';
   
// class Login extends StatefulWidget {
//     static const routeName = '/login';
  
//     const Login({Key? key}) : super(key: key);
   
//     @override
//     State<StatefulWidget> createState() {
//         return _LoginState();
//     }
// }
   
// class _LoginState extends State<Login> {
   
//     // สร้างฟอร์ม key หรือ id ของฟอร์มสำหรับอ้างอิง
//     final _formKey = GlobalKey<FormState>();
 
//     // กำหนดตัวแปรรับค่า
//     final _email = TextEditingController();
//     final _password = TextEditingController();
  
//     @override
//     void initState() {
//       super.initState();
//     }
 
//     // กำหนดสถานะการแสดงแบบรหัสผ่าน
//     bool _isHidden = true;    
//     bool _authenticatingStatus = false;    
 
//     @override
//     void dispose() {
//       _email.dispose(); // ยกเลิกการใช้งานที่เกี่ยวข้องทั้งหมดถ้ามี
//       _password.dispose(); 
//       super.dispose();
//     }    
 
//     @override
//     Widget build(BuildContext context) {
//         // ใช้งาน provider
//         UserProvider userProvider = context.read<UserProvider>();
//         return Scaffold(
//             appBar: AppBar(
//                 title: Text('Login'),
//             ),
//             body: SingleChildScrollView(
//               child: Form(
//                 key: _formKey, // กำหนด key
//                 child: Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Center(
//                       child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                               SizedBox(height: 20.0,), 
//                               FlutterLogo(
//                                 size: 100,
//                               ),
//                               Text('Login Screen'),
//                               TextFormField(
//                                 decoration: InputDecoration(
//                                   hintText: 'Email',
//                                   icon: Icon(Icons.email_outlined),
//                                 ),
//                                 controller: _email, // ผูกกับ TextFormField ที่จะใช้
//                               ), 
//                               SizedBox(height: 5.0,),                                
//                               TextFormField(
//                                 decoration: InputDecoration(
//                                   hintText: 'Password',
//                                   icon: Icon(Icons.vpn_key),
//                                   suffixIcon: IconButton(
//                                     onPressed: (){
//                                       setState(() {
//                                         _isHidden = !_isHidden; // เมื่อกดก็เปลี่ยนค่าตรงกันข้าม
//                                       });
//                                     }, 
//                                     icon: Icon(
//                                       _isHidden // เงื่อนไขการสลับ icon
//                                       ? Icons.visibility_off 
//                                       : Icons.visibility
//                                     ),
//                                   ),
//                                 ),
//                                 controller: _password, // ผูกกับ TextFormField ที่จะใช้                        
//                                 obscureText: _isHidden, // ก่อนซ่อนหรือแสดงข้อความในรูปแบบรหัสผ่าน
//                               ), 
//                               SizedBox(height: 10.0,),                                  
//                               Visibility(
//                                 visible: !_authenticatingStatus,
//                                 child: ElevatedButton(
//                                 onPressed: () async {
//                                   // เปลี่ยนสถานะเป็นกำลังล็อกอิน
//                                   setState(() {
//                                     _authenticatingStatus = !_authenticatingStatus;
//                                   });
 
//                                   // อ้างอิงฟอร์มที่กำลังใช้งาน ตรวจสอบความถูกต้องข้อมูลในฟอร์ม
//                                   if (_formKey.currentState!.validate()) { //หากผ่าน 
//                                     FocusScope.of(context).unfocus(); // ยกเลิดโฟกัส ให้แป้นพิมพ์ซ่อนไป
 
//                                     String email = _email.text;
//                                     String password = _password.text;
 
//                                     // ใช้ provider ส่ง request ล็อกอินไปยัง server
//                                     var result = await userProvider.authen(email, password);
                                 
//                                     // จำลองเปรียบเทียบค่า เพื่อทำการล็อกอิน  
//                                     if(result['success']!=null){ // ล็อกอินผ่าน
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         const SnackBar(content: Text('Login Successful')),
//                                       );
//                                       Navigator.pop(context, true);   // ปิดหน้านี้พร้อมคืนค่า true 
//                                     }else{
//                                       if(result['error']!=null){ // ล็อกอินไม่ผ่านมี error
//                                         String error = result['error'];
//                                         ScaffoldMessenger.of(context).showSnackBar(
//                                            SnackBar(content: Text('${error}..  try agin!')),
//                                         );
//                                         setState(() {
//                                           _authenticatingStatus = !_authenticatingStatus;
//                                         });
//                                       }else{ // ล็อกอินไม่ผ่าน อื่นๆ
//                                         ScaffoldMessenger.of(context).showSnackBar(
//                                            SnackBar(content: Text('Error..  try agin!')),
//                                         );
//                                         setState(() {
//                                           _authenticatingStatus = !_authenticatingStatus;
//                                         });
//                                       }
//                                     }                                       
//                                   }                                
//                                 },
//                                   child: Container( 
//                                     alignment: Alignment.center, 
//                                     width: double.infinity, 
//                                     child: const Text('Login'),  
//                                   ),
//                                 ),
//                               ),
//                               Visibility(
//                                 visible: _authenticatingStatus,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     CircularProgressIndicator(),
//                                     SizedBox(width: 10.0,), 
//                                     Text(" Authenticating ... Please wait")
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(height: 30.0,),   
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text('Or '),
//                                   InkWell(
//                                     child: Text('Register', 
//                                       style: TextStyle(
//                                         decoration: TextDecoration.underline, 
//                                         color: Colors.blue
//                                       )), 
//                                     onTap: () async {
//                                       // เปิดหน้า สมัครสมาชิก โดย แทนที่ route ล็อกอินเดิม
//                                       Navigator.pushReplacement(
//                                         context, 
//                                         MaterialPageRoute(builder: (context) => Register(),
//                                           settings: RouteSettings(
//                                             arguments: null
//                                           ),
//                                         ),
//                                       );    
//                                     },
//                                   )
//                                 ],
//                               )
//                           ],
//                       )
//                   ),
//                 ),
//               ),
//             ),
//         );
//     }
// }