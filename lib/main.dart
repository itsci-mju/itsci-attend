import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/screen/login.dart';
import 'package:flutter_application_mobiletest2/screen/student/detail_student_profile.dart';
import 'package:flutter_application_mobiletest2/screen/student/home_screen.dart';
import 'package:flutter_application_mobiletest2/screen/student/list_subject.dart';
import 'package:flutter_application_mobiletest2/screen/student/scan_screen.dart';
import 'package:flutter_application_mobiletest2/screen/teacher/list_class.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: maincolor,
      ),
      //home: const ListClassTeacherScreen(),
      home: const LoginScreen(),
    );
  }
}
