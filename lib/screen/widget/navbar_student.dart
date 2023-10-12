import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/screen/login.dart';
import 'package:flutter_application_mobiletest2/screen/widget/drawer_student.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../student/edit_student_profile.dart';
import '../student/view_student_subject.dart';

class NavbarStudent extends StatefulWidget {
  const NavbarStudent({super.key});

  @override
  State<NavbarStudent> createState() => _NavbarStudentState();
}

class _NavbarStudentState extends State<NavbarStudent> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool pressed1 = true;
  bool pressed2 = true;
  bool pressed3 = true;

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    return Stack(children: [
      Container(
        color: maincolor,
        height: 50,
        width: pageWidth,
      ),
      IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
    ]);
  }
}
