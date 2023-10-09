import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/controller/login_controller.dart';
import 'package:flutter_application_mobiletest2/controller/user_controller.dart';
import 'package:flutter_application_mobiletest2/model/login.dart';
import 'package:flutter_application_mobiletest2/screen/student/view_student_subject.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<LoginScreen> {
  bool? isLoaded = false;
  bool passToggle = true;
  Login? logins;
  String roleName = "";

  final _formfield = GlobalKey<FormState>();
  final LoginController loginController = LoginController();
  final UserController userController = UserController();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passworldController = TextEditingController();

  // ส่วนของ CheckPlatformExample
  String? _getPlatform() {
    String? platform;

    if (kIsWeb) {
      platform = 'Web';
    } else if (Platform.isAndroid) {
      platform = 'Android';
    } else if (Platform.isIOS) {
      platform = 'iOS';
    } else if (Platform.isFuchsia) {
      platform = 'Fuchsia';
    } else if (Platform.isLinux) {
      platform = 'Linux';
    } else if (Platform.isWindows) {
      platform = 'Windows';
    } else if (Platform.isMacOS) {
      platform = 'macOS';
    }

    return platform;
  }

  void fetchData() async {
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void showLoginFailAlert() {
    QuickAlert.show(
      context: context,
      title: "แจ้งเตือน",
      text: "ชื่อผู้ใช้ หรือ รหัสผ่านไม่ถูกต้อง",
      type: QuickAlertType.error,
      confirmBtnText: "ตกลง",
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? platform = _getPlatform();
    final Size screenSize = MediaQuery.of(context).size;

    final double formWidth = screenSize.width > 600 ? 600 : screenSize.width;
    final double screenHeight = screenSize.height;
    final double formHeight = screenHeight * 1;
    final double formHeight2 = screenHeight * 0.4;

    final double textFieldWidth = formWidth * 0.8;
    final double textFieldHeight = 50;
    final double textFieldFontSize = 20;

    return Scaffold(
      backgroundColor: maincolor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: _formfield,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: formWidth,
                  height: formHeight, // กำหนดความสูงของฟอร์ม
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("images/mjuicon.png"),
                          height: MediaQuery.of(context).size.width *
                              0.4, // กำหนดความสูงเป็น 40% ของความกว้างของหน้าจอ
                          width: MediaQuery.of(context).size.width *
                              0.4, // กำหนดความกว้างเป็น 40% ของความกว้างของหน้าจอ
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            //ถ้าใส่ email ถูก
                            bool usernameValid =
                                RegExp(r"^[MJU]+[0-9]").hasMatch(value!);

                            //กรณีไม่ใส่ username
                            if (value.isEmpty) {
                              return "Enter Username";
                            }
                            //กรณีใส่ usename ผิด
                            else if (!usernameValid) {
                              return "Username Must be MJUรหัสนักศึกษา";
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passworldController,
                          obscureText: passToggle,
                          decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    passToggle = !passToggle;
                                  });
                                },
                                child: Icon(passToggle
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              )),
                          validator: (value) {
                            bool passwordValid =
                                RegExp(r'^.{8,}$').hasMatch(value!);

                            if (value.isEmpty) {
                              return "กรุณากรอก Password";
                            }
                            //กรณีใส่ Password ผิด
                            else if (!passwordValid) {
                              return "กรุณากรอก Password ตั้งแต่ 8 ตัวขึ้นไป";
                            }
                          },
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        InkWell(
                          onTap: () async {
                            if (usernameController.text == "root" &&
                                passworldController.text == "1234") {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString(
                                  'username', usernameController.text);
                              /*Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return const ListRoomScreen();
                              }));*/
                            } else if (_formfield.currentState!.validate()) {
                              http.Response response =
                                  await loginController.doLogin(
                                      usernameController.text,
                                      passworldController.text);

                              if (response.statusCode == 200) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    'username', usernameController.text);
                                print("ผ่าน");
                                //Check Role for Go Screen
                                var jsonResponse = jsonDecode(response.body);
                                List<dynamic> roles = jsonResponse['role'];
                                roleName = roles[0]['role'];
                                if (roleName == "Student") {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return const ViewStudentSubject();
                                  }));
                                } else if (roleName == "Teacher") {
                                  /*Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return const ListClassScreen();
                                  }));*/
                                }
                              } else if (response.statusCode == 409) {
                                showLoginFailAlert();
                                print("ไม่เจอข้อมูล");
                              } else {
                                print("Error");
                              }
                              usernameController.clear();
                              passworldController.clear();
                            }
                          },
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: maincolor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text("Log In",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
