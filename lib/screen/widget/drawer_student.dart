import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/controller/user_controller.dart';
import 'package:flutter_application_mobiletest2/model/user.dart';
import 'package:flutter_application_mobiletest2/screen/login.dart';
import 'package:flutter_application_mobiletest2/screen/student/detail_student_profile.dart';
import 'package:flutter_application_mobiletest2/screen/student/home_screen.dart';
import 'package:flutter_application_mobiletest2/screen/student/list_subject.dart';
import 'package:flutter_application_mobiletest2/screen/student/scan_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerStudentWidget extends StatefulWidget {
  const DrawerStudentWidget({super.key});

  @override
  State<DrawerStudentWidget> createState() => _DrawerStudentWidgettState();
}

class _DrawerStudentWidgettState extends State<DrawerStudentWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final UserController userController = UserController();
  List<Map<String, dynamic>> data = [];
  bool? isLoaded = false;
  User? user;

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    //String? username = "MJU6304106304";

    //print(username);
    if (username != null) {
      user = await userController.get_UserByUsername(username);
      //print(user?.id);

      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: maincolor,
      elevation: 10,
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.white,
                  ),
                  Text(
                    "${user?.fname} ${user?.lname}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20, // ปรับขนาดตามที่ต้องการ
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                size: 30,
                color: Colors.white,
              ),
              minLeadingWidth: 10,
              title:
                  const Text('หน้าหลัก', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const homeScreenForStudent();
                }));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.qr_code_scanner,
                size: 30,
                color: Colors.white,
              ),
              minLeadingWidth: 10,
              title: const Text('สแกนคิวอาร์โค้ด',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const scanScreenForStudent();
                }));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.inventory_outlined,
                size: 30,
                color: Colors.white,
              ),
              minLeadingWidth: 10,
              title: const Text('คลาสเรียน',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const ListSubjectStudentScreen();
                }));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
              minLeadingWidth: 10,
              title: const Text(
                'โปรไฟล์',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const DetailStudentProfile();
                }));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
                color: Colors.white,
              ),
              minLeadingWidth: 10,
              title: const Text('ออกจากระบบ',
                  style: TextStyle(color: Colors.white)),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('username');
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const LoginScreen();
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}
