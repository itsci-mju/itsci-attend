import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/controller/registration_controller.dart';
import 'package:flutter_application_mobiletest2/controller/user_controller.dart';
import 'package:flutter_application_mobiletest2/model/registration.dart';
import 'package:flutter_application_mobiletest2/model/user.dart';
import 'package:flutter_application_mobiletest2/screen/student/attendance_student.dart';
import 'package:flutter_application_mobiletest2/screen/widget/drawer_student.dart';
import 'package:flutter_application_mobiletest2/screen/widget/mainTextStyle.dart';
import 'package:flutter_application_mobiletest2/screen/widget/my_abb_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListSubjectStudentScreen extends StatefulWidget {
  const ListSubjectStudentScreen({super.key});

  @override
  State<ListSubjectStudentScreen> createState() =>
      _ListSubjectStudentScreenState();
}

class _ListSubjectStudentScreenState extends State<ListSubjectStudentScreen> {
  final RegistrationController registrationController =
      RegistrationController();
  final UserController userController = UserController();
  List<Map<String, dynamic>> data = [];
  bool? isLoaded = false;
  List<Registration>? registration;
  String? IdUser;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String? username = prefs.getString('username');
    String? username = "MJU6304106304";

    //print(username);
    if (username != null) {
      User? user = await userController.get_UserByUsername(username);
      print(user?.id);
      if (user != null) {
        IdUser = user.id.toString();
        print(IdUser);
        List<Registration> reg =
            await registrationController.get_ViewSubject(user.id.toString());

        setState(() {
          registration = reg;
          data = reg
              .map((reg) => {
                    'id': reg.id ?? "",
                    'subjectid': reg.section?.course?.subject?.subjectId ?? "",
                    'subjectname':
                        reg.section?.course?.subject?.subjectName ?? "",
                    'type': reg.section?.type ?? "",
                    'group': reg.section?.sectionNumber,
                    'startTime': reg.section?.startTime,
                    'duration': reg.section?.duration,
                  })
              .toList();
          isLoaded = true;
        });
      }
    }
  }

  String addTime(String timeString, int hoursToAdd) {
    // แปลงเวลาจากสตริงเป็น DateTime
    final originalTime = DateTime.parse("2023-01-01 $timeString:00");

    // บวกเวลาในรูปแบบของนาที
    final newTime = originalTime.add(Duration(hours: hoursToAdd));

    // แปลงผลลัพธ์กลับเป็นสตริง
    final newTimeString =
        "${newTime.hour}:${newTime.minute.toString().padLeft(2, '0')}";

    // ทำอะไรกับเวลาใหม่ ที่คุณต้องการ เช่น พิมพ์ผลลัพธ์
    print(" TestNewTime: ${newTimeString}");
    return "${newTime.hour}:${newTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: kMyAppBar,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      endDrawer: const DrawerStudentWidget(),
      body: ListView(
        children: <Widget>[
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              const Text(
                "เลือกรายวิชาที่ต้องการดูการเข้าเรียน",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              for (var item in data)
                Container(
                  width: 330,
                  height: 100,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    color: maincolor,
                    child: InkWell(
                      onTap: () async {
                        //print(item['id'].toString());
                        await Future.delayed(Duration
                            .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return AttendanceStudentScreen(
                            regId: item['id'].toString(),
                          );
                        }));
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${item['subjectid']} ",
                                          style: CustomTextStyle.TextGeneral),
                                      Text(" ${item['subjectname']}",
                                          style: CustomTextStyle.TextGeneral),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("กลุ่ม: ${item['group']} ",
                                          style: CustomTextStyle.TextGeneral),
                                      Text(" ประเภท: ${item['type']}",
                                          style: CustomTextStyle.TextGeneral),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          "${item['startTime'] != null ? item['startTime'].substring(0, 5) : 'N/A'}",
                                          style: CustomTextStyle.TextGeneral),
                                      const Text(" - ",
                                          style: CustomTextStyle.TextGeneral),
                                      Text(
                                        "${addTime(item['startTime'].substring(0, 5), item['duration'])}",
                                        style: CustomTextStyle.TextGeneral,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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
