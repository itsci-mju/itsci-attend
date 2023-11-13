import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/controller/login_controller.dart';
import 'package:flutter_application_mobiletest2/controller/user_controller.dart';
import 'package:flutter_application_mobiletest2/model/user.dart';
import 'package:flutter_application_mobiletest2/screen/teacher/detail_teacher_profile.dart';
import 'package:flutter_application_mobiletest2/screen/widget/drawer_teacher.dart';
import 'package:flutter_application_mobiletest2/screen/widget/mainTextStyle.dart';
import 'package:flutter_application_mobiletest2/screen/widget/my_abb_bar.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class EditTeacherPassword extends StatefulWidget {
  final String id;
  const EditTeacherPassword({super.key, required this.id});

  @override
  State<EditTeacherPassword> createState() => _EditTeacherPasswordState();
}

class _EditTeacherPasswordState extends State<EditTeacherPassword> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  final LoginController loginController = LoginController();
  final UserController userController = UserController();
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  bool? isLoaded = false;
  bool passToggle1 = true;
  bool passToggle2 = true;
  bool passToggle3 = true;
  User? user;
  String? username;
  String? password;
  String? originalPassword;

  void userData(String id) async {
    user = await userController.get_Userid(id);
    username = user?.login?.username.toString();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    userData(widget.id);
  }

  void showSuccessToChangeUserAlert() {
    QuickAlert.show(
      context: context,
      title: "การแก้ไขรหัสผ่านสำเร็จ",
      text: "รหัสผ่านถูกแก้ไขเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      barrierDismissible: false,
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DetailTeacherProfile()),
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      endDrawer: const DrawerTeacherWidget(),
      body: isLoaded == false
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(maincolor),
                  ),
                ),
              ],
            )
          : Form(
              key: _formfield,
              child: Column(children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 40, bottom: 20),
                      decoration: BoxDecoration(
                        //color: maincolor,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "เปลี่ยนรหัสผ่าน",
                                style: TextStyle(
                                  color: maincolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: oldPasswordController,
                              obscureText: passToggle1,
                              decoration: InputDecoration(
                                  labelText: 'รหัสผ่านเดิม :',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: const TextStyle(
                                      color:
                                          Colors.black, // กำหนดสีของ labelText
                                      fontSize:
                                          20.0, // กำหนดขนาดตัวอักษรของ labelText
                                      fontWeight: FontWeight.bold),
                                  errorStyle: const TextStyle(),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        passToggle1 = !passToggle1;
                                      });
                                    },
                                    child: Icon(passToggle1
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "กรุณากรอกรหัสผ่านเดิม*";
                                } else if (value != password) {
                                  return "รหัสผ่านเดิมไม่ถูกต้อง";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: newPasswordController,
                              obscureText: passToggle2,
                              decoration: InputDecoration(
                                  labelText: 'รหัสผ่านใหม่ :',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: const TextStyle(
                                      color:
                                          Colors.black, // กำหนดสีของ labelText
                                      fontSize:
                                          20.0, // กำหนดขนาดตัวอักษรของ labelText
                                      fontWeight: FontWeight.bold),
                                  errorStyle: const TextStyle(),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        passToggle2 = !passToggle2;
                                      });
                                    },
                                    child: Icon(passToggle2
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  )),
                              validator: (value) {
                                bool subjectNameValid = RegExp(
                                        r'^(?=.*[A-Za-z])(?=.*[!@#\$%^&*])[A-Za-z0-9!@#\$%^&*]{8,16}$')
                                    .hasMatch(value!);
                                if (value.isEmpty) {
                                  return "กรุณากรอกรหัสผ่านใหม่*";
                                } else if (!subjectNameValid) {
                                  return "กรุณากรอกรหัสผ่านเป็นภาษาอังกฤษอักษรพิเศษ\nและตัวเลขความยาว 8-16 ตัว";
                                } else if (newPasswordController.text ==
                                    oldPasswordController.text) {
                                  return "รหัสผ่านใหม่ต้องไม่เหมือนรหัสผ่านเดิม!!";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: passToggle3,
                              decoration: InputDecoration(
                                  labelText: 'ยืนยันรหัสผ่านใหม่ :',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: const TextStyle(
                                      color:
                                          Colors.black, // กำหนดสีของ labelText
                                      fontSize:
                                          20.0, // กำหนดขนาดตัวอักษรของ labelText
                                      fontWeight: FontWeight.bold),
                                  errorStyle: const TextStyle(),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        passToggle3 = !passToggle3;
                                      });
                                    },
                                    child: Icon(passToggle3
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "กรุณากรอกยืนยันรหัสผ่าน*";
                                } else if (value !=
                                    newPasswordController.text) {
                                  return "ยืนยันรหัสผ่านไม่ตรงกัน";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: double
                                        .infinity, // กำหนดความกว้างของปุ่ม
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0), // กำหนดมุม
                                        ),
                                      ),
                                      onPressed: () async {
                                        print("Check Password ${password}");
                                        print("Check user ${username}");
                                        print(
                                            "Check Password ${oldPasswordController.text}");
                                        http.Response response =
                                            await loginController
                                                .change_Password(username!,
                                                    oldPasswordController.text);
                                        if (response.statusCode == 200) {
                                          print("ผ่านแล้ว");
                                          password = oldPasswordController.text;
                                        } else {
                                          password = "";
                                        }
                                        if (_formfield.currentState!
                                            .validate()) {
                                          http.Response response =
                                              await userController
                                                  .updatePasswordTeacher(
                                                      '${user?.login?.id.toString()}',
                                                      newPasswordController
                                                          .text);

                                          if (response.statusCode == 200) {
                                            showSuccessToChangeUserAlert();
                                            print("บันทึกสำเร็จ");
                                          }
                                        }
                                      },
                                      child: const Text("ยืนยัน",
                                          style: CustomTextStyle.TextGeneral),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    )
                  ],
                )
              ]),
            ),
    );
  }
}
