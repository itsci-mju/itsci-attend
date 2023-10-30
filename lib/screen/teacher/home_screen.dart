import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/screen/teacher/list_class.dart';
import 'package:flutter_application_mobiletest2/screen/widget/drawer_teacher.dart';
import 'package:flutter_application_mobiletest2/screen/widget/my_abb_bar.dart';

class homeScreenForTeacher extends StatefulWidget {
  const homeScreenForTeacher({super.key});

  @override
  State<homeScreenForTeacher> createState() => _homeScreenForTeacherState();
}

class _homeScreenForTeacherState extends State<homeScreenForTeacher> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    double pageWidth = MediaQuery.of(context).size.width;

    final scaffoldKey = GlobalKey<ScaffoldState>();

    double formHeight;
    double formWidth;

    if (screenWidth > 1000) {
      formWidth = 300;
      formHeight = 300;
    } else {
      formWidth = screenWidth * 0.2; // เปลี่ยนค่าตามที่คุณต้องการ
      formHeight = screenHeight * 0.2; // เปลี่ยนค่าตามที่คุณต้องการ
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: kMyAppBar,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      endDrawer: const DrawerTeacherWidget(),
      body: ListView(children: [
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            Container(
              width: 200,
              height: 200,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35)),
                color: maincolor,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const ListClassTeacherScreen();
                    }));
                  },
                  child: FractionallySizedBox(
                    widthFactor: 1.0, // ให้เท่ากับความกว้างของ Container
                    heightFactor: 1.0, // ให้เท่ากับความสูงของ Container
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: IntrinsicWidth(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: [
                              FractionallySizedBox(
                                widthFactor: 0.7,
                                child: Image.asset(
                                  'images/book-stack.png',
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              const FractionallySizedBox(
                                widthFactor: 1,
                                child: Center(
                                  child: Text(
                                    "คลาสเรียน",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
