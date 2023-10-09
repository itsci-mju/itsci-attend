import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/screen/student/scan_screen.dart';
import 'package:flutter_application_mobiletest2/screen/widget/my_abb_bar.dart';
import 'package:flutter_application_mobiletest2/screen/widget/navbar_student.dart';

class homeScreenForStudent extends StatefulWidget {
  const homeScreenForStudent({super.key});

  @override
  State<homeScreenForStudent> createState() => _homeScreenForStudentState();
}

class _homeScreenForStudentState extends State<homeScreenForStudent> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

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
      appBar: kMyAppBar,
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            children: [
              //NavbarStudent(),
              Padding(
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
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                ),
                                FractionallySizedBox(
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
              SizedBox(
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
                      // ทำการนำไปยังหน้าอื่น ในกรณีนี้คุณสามารถใช้ pushReplacement หรือ push ไปยังหน้าที่คุณต้องการ
                      /*Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            // ตรงนี้คุณสามารถกำหนดหน้าที่คุณต้องการแสดงหรือนำไปยังหน้าอื่น
                            return const scanScreenForStudent();
                          },
                        ),
                      );*/
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
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                ),
                                FractionallySizedBox(
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
