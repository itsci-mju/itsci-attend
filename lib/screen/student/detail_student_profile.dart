import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/controller/student_controller.dart';
import 'package:flutter_application_mobiletest2/controller/user_controller.dart';
import 'package:flutter_application_mobiletest2/model/user.dart';
import 'package:flutter_application_mobiletest2/screen/student/edit_student_password.dart';
import 'package:flutter_application_mobiletest2/screen/widget/drawer_student.dart';
import 'package:flutter_application_mobiletest2/screen/widget/mainTextStyle.dart';
import 'package:flutter_application_mobiletest2/screen/widget/my_abb_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailStudentProfile extends StatefulWidget {
  const DetailStudentProfile({super.key});

  @override
  State<DetailStudentProfile> createState() => _DetailStudentProfileState();
}

class _DetailStudentProfileState extends State<DetailStudentProfile> {
  TextEditingController idController = TextEditingController();
  TextEditingController useridController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  DateTime selecteData = DateTime.now();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController typeuserController = TextEditingController();
  TextEditingController loginidController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final UserController userController = UserController();
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  List<Map<String, dynamic>> data = [];
  bool? isLoaded = false;
  String? IdUser;
  User? user;

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    //String? username = "MJU6304106304";

    //print(username);
    if (username != null) {
      user = await userController.get_UserByUsername(username);
      print("Check User ID : ${user?.id}");
      if (user != null) {
        setState(() {
          isLoaded = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      endDrawer: const DrawerStudentWidget(),
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
                Center(
                  child: Column(children: const [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    Icon(
                      Icons.person,
                      size: 100,
                      color: maincolor,
                    ),
                  ]),
                ),
                Column(children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, top: 20),
                    decoration: BoxDecoration(
                      //color: maincolor,
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "ชื่อ : ${user?.fname ?? ""}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "นามสกุล : ${user?.lname ?? ""}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "รหัสนักศึกษา : ${user?.userid ?? ""}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "อีเมล : ${user?.email ?? ""}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "ชื่อผู้ใช้ : ${user?.login?.username ?? ""}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "เพศ : ${user?.gender ?? ""}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "วัน เดือน ปีเกิด : ${DateFormat('dd/MM/yyyy').format(selecteData)}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Container(
                              width: 150, // กำหนดความกว้างของปุ่ม
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20.0), // กำหนดมุม
                                  ),
                                ),
                                onPressed: () async {
                                  await Future.delayed(Duration
                                      .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return EditStudentPassword(
                                          id: '${user?.id.toString()}');
                                    }),
                                    (route) => false,
                                  );
                                },
                                child: const Text("แก้ไขรหัสผ่าน"),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ]),
                  )
                ]),
              ]),
            ),
    );
  }
}
