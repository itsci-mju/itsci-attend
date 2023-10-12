import 'package:flutter/material.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/screen/widget/drawer_student.dart';

final double appBarHeight = kToolbarHeight;
final double imageHeight = appBarHeight * 1;

var kMyAppBar = AppBar(
  title: Image.asset(
    'images/mju_logo_main-resize.png',
    height: imageHeight,
  ),
  toolbarHeight: appBarHeight,
  iconTheme: IconThemeData(color: maincolor),
  backgroundColor: Color.fromARGB(255, 255, 255, 255),
  elevation: 10,
);
