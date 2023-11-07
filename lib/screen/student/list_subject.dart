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
  List<Map<String, dynamic>> filterSemesterData = [];
  List<Map<String, dynamic>> filterTermData = [];
  bool? isLoaded = false;
  List<Registration>? registration;
  String? IdUser;
  String? selectedSemester;
  List<String> semesters = ['ทั้งหมด'];
  String? selectedTerm;
  List<String> terms = ['ทั้งหมด', '1', '2'];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    //String? username = "MJU6304106304";

    //print(username);
    if (username != null) {
      User? user = await userController.get_UserByUsername(username);
      IdUser = user?.id.toString();
      //print(user?.id);
      if (user != null) {
        //print(IdUser);
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
                    'semester': reg.section?.course?.semester,
                    'term': reg.section?.course?.term,
                  })
              .toList();
          isLoaded = true;
          // เพิ่มค่า semester ลงใน semesters
          data.forEach((row) {
            String? semester = row['semester'].toString();
            if (semester != null && !semesters.contains(semester)) {
              semesters.add(semester);
            }
          });
          filterSemesterData = data
              .where((row) =>
                  selectedSemester == 'ทั้งหมด' ||
                  selectedSemester == null ||
                  row['semester'].toString() == selectedSemester)
              .toList();
          filterData();
        });
      }
    }
  }

  void filterData() {
    filterTermData = filterSemesterData.where((row) {
      return (selectedTerm == 'ทั้งหมด' ||
          selectedTerm == null ||
          row['term'].toString() == selectedTerm);
    }).toList();
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
      endDrawer: const DrawerStudentWidget(),
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
          : Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: 2.0,
                    ),
                  )),
                  child: Column(children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    const Text(
                      "เลือกรายวิชาที่ต้องการดูการเข้าเรียน",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 50,
                          alignment: AlignmentDirectional.centerStart,
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 0.0, right: 10.0, bottom: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 0, 0, 0), // กำหนดสีขอบของ Container
                              width: 1.0, // กำหนดความกว้างขอบของ Container
                            ),
                          ),
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: selectedSemester,
                            hint: const Text(
                              'ปีการศึกษา',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            items: semesters.map((semester) {
                              return DropdownMenuItem(
                                value: semester,
                                child: Text(
                                  semester,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSemester = newValue;
                                filterSemesterData = data
                                    .where((row) =>
                                        selectedSemester == 'ทั้งหมด' ||
                                        selectedSemester == null ||
                                        row['semester'].toString() ==
                                            selectedSemester)
                                    .toList();
                                selectedTerm = null;
                                filterData();
                              });
                            },
                            decoration: const InputDecoration.collapsed(
                              border: InputBorder.none,
                              hintText:
                                  '', // กำหนด border เป็น InputBorder.none เพื่อลบ underline
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 130,
                          height: 50,
                          alignment: AlignmentDirectional.centerStart,
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 0.0, right: 10.0, bottom: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 0, 0, 0), // กำหนดสีขอบของ Container
                              width: 1.0, // กำหนดความกว้างขอบของ Container
                            ),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration.collapsed(
                              border: InputBorder.none,
                              hintText:
                                  '', // กำหนด border เป็น InputBorder.none เพื่อลบ underline
                            ),
                            isExpanded: true,
                            hint: const Text(
                              'เทอม',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            value: selectedTerm,
                            items: terms.map((term) {
                              return DropdownMenuItem(
                                value: term,
                                child: Text(term),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedTerm = newValue;
                                filterData();
                              });
                            },
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: [
                          for (var item in filterTermData)
                            Container(
                              width: 330,
                              //height: 100,
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
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return AttendanceStudentScreen(
                                        regId: item['id'].toString(),
                                      );
                                    }));
                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                children: [
                                                  Text("${item['subjectid']} ",
                                                      style: CustomTextStyle
                                                          .TextGeneral),
                                                  Text(
                                                    " ${item['subjectname']}",
                                                    style: CustomTextStyle
                                                        .TextGeneral,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines:
                                                        2, // กำหนดจำนวนบรรทัดสูงสุดที่แสดง
                                                    textAlign: TextAlign
                                                        .center, // จัดให้อยู่ตรงกลาง,
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      "กลุ่ม: ${item['group']} ",
                                                      style: CustomTextStyle
                                                          .TextGeneral),
                                                  Text(
                                                      " ประเภท: ${item['type']}",
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
                                                      "${item['startTime'] != null ? item['startTime'].substring(0, 5) : 'N/A'}",
                                                      style: CustomTextStyle
                                                          .TextGeneral),
                                                  const Text(" - ",
                                                      style: CustomTextStyle
                                                          .TextGeneral),
                                                  Text(
                                                    "${addTime(item['startTime'].substring(0, 5), item['duration'])}",
                                                    style: CustomTextStyle
                                                        .TextGeneral,
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
                ),
              ],
            ),
    );
  }
}
