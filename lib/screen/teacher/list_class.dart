import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/controller/registration_controller.dart';
import 'package:flutter_application_mobiletest2/controller/section_controller.dart';
import 'package:flutter_application_mobiletest2/controller/user_controller.dart';
import 'package:flutter_application_mobiletest2/model/registration.dart';
import 'package:flutter_application_mobiletest2/model/section.dart';
import 'package:flutter_application_mobiletest2/model/user.dart';
import 'package:flutter_application_mobiletest2/screen/teacher/attendance_teacher.dart';
import 'package:flutter_application_mobiletest2/screen/teacher/view_teacher_qrcode.dart';

import 'package:flutter_application_mobiletest2/screen/widget/drawer_teacher.dart';
import 'package:flutter_application_mobiletest2/screen/widget/mainTextStyle.dart';
import 'package:flutter_application_mobiletest2/screen/widget/my_abb_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListClassTeacherScreen extends StatefulWidget {
  const ListClassTeacherScreen({super.key});

  @override
  State<ListClassTeacherScreen> createState() => _ListClassTeacherScreenState();
}

class _ListClassTeacherScreenState extends State<ListClassTeacherScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final UserController userController = UserController();
  final SectionController sectionController = SectionController();
  final RegistrationController registrationController =
      RegistrationController();
  List<Map<String, dynamic>> data = [];
  bool? isLoaded = false;
  String? IdUser;
  String? sectionId;
  List<Registration>? registration;
  List<Section>? section;
  late List<bool> isMark1ClickedList;

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    //String? username = "MJU6304106304";

    //print(username);
    if (username != null) {
      User? user = await userController.get_UserByUsername(username);
      //print(user?.id);
      if (user != null) {
        IdUser = user.id.toString();
        List<Section> sec =
            await sectionController.listSectionsByUserId(IdUser!);

        setState(() {
          section = sec;
          data = sec
              .map((sec) => {
                    'id': sec.id ?? "",
                    'subjectid': sec.course?.subject?.subjectId ?? "",
                    'subjectname': sec.course?.subject?.subjectName ?? "",
                    'type': sec.type ?? "",
                    'group': sec.sectionNumber,
                    'startTime': sec.startTime,
                    'duration': sec.duration,
                  })
              .toList();
          isMark1ClickedList = List.generate(data.length, (index) => false);
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
    //print(" TestNewTime: ${newTimeString}");
    return "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";
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
      endDrawer: const DrawerTeacherWidget(),
      body: isLoaded == false
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(maincolor),
                  ),
                ),
              ],
            )
          : ListView(
              children: <Widget>[
                Column(
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    const Text(
                      "เลือกรายวิชาที่ต้องการดูการเข้าเรียน",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    for (var index = 0; index < data.length; index++)
                      Container(
                        width: 330,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          color: maincolor,
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                isMark1ClickedList = List.generate(
                                    data.length, (i) => i == index);
                              });
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center, // จัดให้ children อยู่กึ่งกลางแนวดิ่ง
                                          children: [
                                            Center(
                                              child: Text(
                                                  "${data[index]['subjectid']}",
                                                  style: CustomTextStyle
                                                      .TextGeneral),
                                            ),
                                            Center(
                                              child: Text(
                                                "${data[index]['subjectname']}",
                                                style:
                                                    CustomTextStyle.TextGeneral,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines:
                                                    2, // กำหนดจำนวนบรรทัดสูงสุดที่แสดง
                                                textAlign: TextAlign
                                                    .center, // จัดให้อยู่ตรงกลาง
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "กลุ่ม: ${data[index]['group']} ",
                                                style: CustomTextStyle
                                                    .TextGeneral),
                                            Text(
                                                " ประเภท: ${data[index]['type']}",
                                                style: CustomTextStyle
                                                    .TextGeneral),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "${data[index]['startTime'] != null ? data[index]['startTime'].substring(0, 5) : 'N/A'}",
                                                style: CustomTextStyle
                                                    .TextGeneral),
                                            const Text(" - ",
                                                style: CustomTextStyle
                                                    .TextGeneral),
                                            Text(
                                              "${addTime(data[index]['startTime'].substring(0, 5), data[index]['duration'])}",
                                              style:
                                                  CustomTextStyle.TextGeneral,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        //Mark1
                                        Visibility(
                                          visible: isMark1ClickedList[
                                              index], // เปลี่ยนตามตัวแปรสถานะ
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 300,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors
                                                        .white, // กำหนดสีพื้นหลังของปุ่ม
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0), // กำหนดมุม
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                      return TeacherGenerateQR(
                                                          sectionId: data[index]
                                                                  ['id']
                                                              .toString());
                                                    }));
                                                  },
                                                  child: const Text("QR CODE",
                                                      style: CustomTextStyle
                                                          .createFontStyle),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Container(
                                                width: 300,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors
                                                        .white, // กำหนดสีพื้นหลังของปุ่ม
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0), // กำหนดมุม
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                      return AttendanceTeacherScreen(
                                                          sectionId: data[index]
                                                                  ['id']
                                                              .toString());
                                                    }));
                                                  },
                                                  child: const Text(
                                                      "การเข้าเรียน",
                                                      style: CustomTextStyle
                                                          .createFontStyle),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
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
