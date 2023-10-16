import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter_application_mobiletest2/screen/widget/drawer_teacher.dart';
import 'package:flutter_application_mobiletest2/screen/widget/my_abb_bar.dart';

class ListClassTeacherScreen extends StatefulWidget {
  const ListClassTeacherScreen({super.key});

  @override
  State<ListClassTeacherScreen> createState() => _ListClassTeacherScreenState();
}

class _ListClassTeacherScreenState extends State<ListClassTeacherScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: kMyAppBar,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      endDrawer: const DrawerTeacherWidget(),
    );
  }
}
