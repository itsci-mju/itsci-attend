import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/screen/login.dart';
import 'package:flutter_application_mobiletest2/screen/teacher/home_screen.dart';
import 'package:flutter_application_mobiletest2/screen/teacher/list_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerTeacherWidget extends StatefulWidget {
  const DrawerTeacherWidget({super.key});

  @override
  State<DrawerTeacherWidget> createState() => _DrawerTeacherWidgetState();
}

class _DrawerTeacherWidgetState extends State<DrawerTeacherWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: maincolor,
      elevation: 10,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const DrawerHeader(
              child: Icon(
                Icons.person,
                size: 100,
                color: Colors.white,
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
                  return const homeScreenForTeacher();
                }));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.menu_book,
                size: 30,
                color: Colors.white,
              ),
              minLeadingWidth: 10,
              title:
                  const Text('รายวิชา', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const ListClassTeacherScreen();
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
                'แก้ไขข้อมูลส่วนตัว',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                /*Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const DetailStudentProfile();
                }));*/
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
