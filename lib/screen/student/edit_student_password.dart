import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/controller/student_controller.dart';
import 'package:flutter_application_mobiletest2/controller/user_controller.dart';
import 'package:flutter_application_mobiletest2/model/user.dart';
import 'package:flutter_application_mobiletest2/screen/student/detail_student_profile.dart';
import 'package:flutter_application_mobiletest2/screen/widget/drawer_student.dart';
import 'package:flutter_application_mobiletest2/screen/widget/mainTextStyle.dart';
import 'package:flutter_application_mobiletest2/screen/widget/my_abb_bar.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class EditStudentPassword extends StatefulWidget {
  final String id;
  const EditStudentPassword({super.key, required this.id});

  @override
  State<EditStudentPassword> createState() => _EditStudentPasswordState();
}

class _EditStudentPasswordState extends State<EditStudentPassword> {
  TextEditingController passwordController = TextEditingController();
  final UserController userController = UserController();
  final StudentController studentController = StudentController();
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  bool? isLoaded = false;
  bool passToggle = true;
  User? user;
  String? IdUser;

  void userData(String id) async {
    user = await userController.get_Userid(id);
    setState(() {
      IdUser = id.toString();
      isLoaded = false;
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
      text: "ข้อมูลรหัสผ่านถูกแก้ไขเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DetailStudentProfile(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      endDrawer: const DrawerStudentWidget(),
      body: Form(
        key: _formfield,
        child: Column(children: [
          Center(
            child: Column(children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              Icon(
                Icons.person,
                size: 100,
                color: maincolor,
              ),
            ]),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                padding: const EdgeInsets.only(
                    left: 40, right: 40, top: 20, bottom: 20),
                decoration: BoxDecoration(
                  //color: maincolor,
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "รหัสผ่าน : ",
                        style: CustomTextStyle.createFontStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 200,
                        child: Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            obscureText: passToggle,
                            decoration: InputDecoration(
                                errorStyle: const TextStyle(),
                                filled: true, // เปิดการใช้งานการเติมพื้นหลัง
                                fillColor: Colors.white,
                                border:
                                    InputBorder.none, // กำหนดให้ไม่มีเส้นขอบ
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
                              bool subjectNameValid = RegExp(
                                      r'^(?=.*[A-Za-z0-9!@#\$%^&*])[A-Za-z0-9!@#\$%^&*]{8,16}$')
                                  .hasMatch(value!);
                              if (value.isEmpty) {
                                return "กรุณากรอกรหัสผ่าน*";
                              } else if (!subjectNameValid) {
                                return "กรุณากรอกรหัสผ่านเป็นภาษาอังกฤษ อักษรพิเศษและตัวเลขความยาว 8-16 ให้ถูกต้อง";
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "ยืนยันรหัสผ่าน : ",
                        style: CustomTextStyle.createFontStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 500,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: passToggle,
                          decoration: InputDecoration(
                              errorStyle: const TextStyle(),
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
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
                            if (value!.isEmpty) {
                              return "กรุณายืนยันรหัสผ่าน*";
                            } else if (value != passwordController.text) {
                              return "รหัสผ่านไม่ตรงกัน";
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 200, // กำหนดความกว้างของปุ่ม
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20.0), // กำหนดมุม
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formfield.currentState!.validate()) {
                                    http.Response response =
                                        await studentController
                                            .updatePasswordStudent(
                                                '${user?.login?.id.toString()}',
                                                passwordController.text);

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
                            Container(
                              width: 200, // กำหนดความกว้างของปุ่ม
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, // กำหนดสีพื้นหลังของปุ่ม
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20.0), // กำหนดมุม
                                  ),
                                ),
                                onPressed: () async {
                                  await Future.delayed(Duration
                                      .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return const DetailStudentProfile();
                                  }));
                                },
                                child: const Text("ยกเลิก",
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
