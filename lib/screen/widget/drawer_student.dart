import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/screen/login.dart';
import 'package:flutter_application_mobiletest2/screen/student/home_screen.dart';
import 'package:flutter_application_mobiletest2/screen/student/list_subject.dart';
import 'package:flutter_application_mobiletest2/screen/student/scan_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerStudentWidget extends StatelessWidget {
  const DrawerStudentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double kDrawerWidth = 200;

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
              title:
                  const Text('แสกน QR', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const scanScreenForStudent();
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
                'แก้ไขข้อมูลส่วนตัว',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                /*Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const StudentListScreen();
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
