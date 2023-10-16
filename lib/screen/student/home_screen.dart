import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/controller/user_controller.dart';
import 'package:flutter_application_mobiletest2/model/user.dart';
import 'package:flutter_application_mobiletest2/screen/student/list_subject.dart';
import 'package:flutter_application_mobiletest2/screen/student/scan_screen.dart';
import 'package:flutter_application_mobiletest2/screen/widget/drawer_student.dart';
import 'package:flutter_application_mobiletest2/screen/widget/my_abb_bar.dart';

import 'package:shared_preferences/shared_preferences.dart';

class homeScreenForStudent extends StatefulWidget {
  const homeScreenForStudent({super.key});

  @override
  State<homeScreenForStudent> createState() => _homeScreenForStudentState();
}

class _homeScreenForStudentState extends State<homeScreenForStudent> {
  final UserController userController = UserController();
  List<Map<String, dynamic>> data = [];
  bool? isLoaded = false;
  String? IdUser;
  String? userID;

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    //String? username = "MJU6304106304";

    //print(username);
    if (username != null) {
      User? user = await userController.get_UserByUsername(username);
      print(user?.id);
      if (user != null) {
        IdUser = user.id.toString();
        userID = user.userid.toString();
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
      endDrawer: const DrawerStudentWidget(),
      body: ListView(
        children: [
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
                      // ทำการนำไปยังหน้าอื่น ในกรณีนี้คุณสามารถใช้ pushReplacement หรือ push ไปยังหน้าที่คุณต้องการ
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            // ตรงนี้คุณสามารถกำหนดหน้าที่คุณต้องการแสดงหรือนำไปยังหน้าอื่น
                            return const scanScreenForStudent();
                          },
                        ),
                      );
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
                                    'images/qr-code.png',
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                ),
                                const FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Center(
                                    child: Text(
                                      "สแกนคิวอาร์โค้ด",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
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
              const SizedBox(
                height: 20,
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
                        return const ListSubjectStudentScreen();
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
                                    'images/immigration.png',
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                ),
                                const FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Center(
                                    child: Text(
                                      "การเข้าเรียน",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
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
        ],
      ),
    );
  }
}
