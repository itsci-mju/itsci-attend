import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/controller/attendanceschedule_controller.dart';
import 'package:flutter_application_mobiletest2/controller/section_controller.dart';
import 'package:flutter_application_mobiletest2/model/attendanceSchedule.dart';
import 'package:flutter_application_mobiletest2/screen/widget/drawer_teacher.dart';
import 'package:flutter_application_mobiletest2/screen/widget/mainTextStyle.dart';
import 'package:flutter_application_mobiletest2/screen/widget/my_abb_bar.dart';
import 'package:intl/intl.dart';

class AttendanceTeacherScreen extends StatefulWidget {
  final String sectionId;
  const AttendanceTeacherScreen({super.key, required this.sectionId});

  @override
  State<AttendanceTeacherScreen> createState() =>
      _AttendanceTeacherScreenState();
}

class _AttendanceTeacherScreenState extends State<AttendanceTeacherScreen> {
  final SectionController sectionController = SectionController();
  final AttendanceScheduleController attendanceScheduleController =
      AttendanceScheduleController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> data = [];
  List<AttendanceSchedule>? attendance;
  bool? isLoaded = false;
  bool checkInTimeandType = false;
  int? weekNumCheck = 1;
  int? sectionid;
  String? type;
  String? checkInTime;
  String? selectedDropdownValue;
  String? subjectid;
  String? statusCheck;

  void showAtten(String week, String secid) async {
    List<AttendanceSchedule> atten = await attendanceScheduleController
        .listAttendanceScheduleBySectionIdAndWeek(week, secid);

    setState(() {
      attendance = atten;
      data = atten
          .where((atten) => atten.weekNo == int.parse(week))
          .map((atten) => {
                'subjectid':
                    atten.registration?.section?.course?.subject?.subjectId ??
                        "",
                'userid': atten.registration?.user?.userid ?? "",
                'weekNo': atten.weekNo ?? "",
                'checkInTime': atten.checkInTime ?? "",
                'status': atten.status ?? "",
                'type': atten.registration?.section?.type ?? "",
              })
          .toList();
      subjectid = data.isNotEmpty ? data[0]['subjectid'] : null;
      type = data.isNotEmpty ? data[0]['type'] : null;
      checkInTime = data.isNotEmpty ? data[0]['checkInTime'] : null;
      if (checkInTime != null && type != null) {
        checkInTimeandType = true;
      } else {
        checkInTimeandType = false;
      }
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    showAtten(weekNumCheck!.toString(), widget.sectionId);
  }

  String weekNum = '1';
  var weekNumItems = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: kMyAppBar,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      endDrawer: const DrawerTeacherWidget(),
      body: ListView(children: <Widget>[
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: maincolor,
                //color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  AttenHeader(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("สัปดาห์ที่ ",
                          style: CustomTextStyle.TextGeneral),
                      Container(
                        width: 100,
                        height: 40,
                        alignment: Alignment.center,
                        child: Card(
                          elevation: 3,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: weekNum,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            icon: const Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      20), // กำหนดการเว้นระหว่างไอคอนและเนื้อหาที่นี่
                              child: Icon(Icons.keyboard_arrow_down),
                            ), // กำหนดไอคอนที่นี่
                            iconSize: 24, // ขนาดของไอคอน
                            iconEnabledColor: Colors.black,
                            items: weekNumItems.map(
                              (String weekNumItems) {
                                return DropdownMenuItem(
                                  value: weekNumItems,
                                  child: Center(
                                    child: Text(
                                      "$weekNumItems",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                weekNum = newValue!;
                                showAtten(weekNum, widget.sectionId);
                              });
                            },
                            underline: const SizedBox(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              children: data.map((item) {
                final checkInTime =
                    DateTime.parse(item['checkInTime']).toLocal();
                final timeFormatter = DateFormat('HH:mm:ss');
                final formattedTime = timeFormatter.format(checkInTime);
                String statusCheck = item['status'];
                IconData iconData = Icons.info;
                Color iconColor = Colors.black;
                if (statusCheck == 'เข้าเรียนปกติ') {
                  iconData = Icons.check_circle;
                  iconColor = Colors.green;
                } else if (statusCheck == 'เข้าเรียนสาย') {
                  iconData = Icons.access_time;
                  iconColor = Colors.orange;
                } else if (statusCheck == 'ขาดเรียน') {
                  iconData = Icons.cancel;
                  iconColor = Colors.red;
                } else {
                  iconData = Icons.info;
                  iconColor = Colors.black;
                }
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text("รหัสนักศึกษา: ${item['userid']}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Text(" สถานะ: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Icon(
                        iconData,
                        color: iconColor,
                      ),

                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("เวลาเข้าเรียน: $formattedTime",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),*/
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        )
      ]),
    );
  }

  Widget AttenHeader() {
    if (checkInTimeandType) {
      return Column(
        children: [
          const Text("การเข้าเรียน", style: CustomTextStyle.TextHeadBar),
          const SizedBox(
            height: 5,
          ),
          Text("รหัสวิชา: ${subjectid ?? ""}",
              style: CustomTextStyle.TextGeneral),
          const SizedBox(
            height: 5,
          ),
          Text("ประเภท: ${type ?? ""}", style: CustomTextStyle.TextGeneral),
          const SizedBox(
            height: 5,
          ),
          Text(
              "วันที่เข้าเรียน : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(checkInTime!).toLocal())}",
              style: CustomTextStyle.TextGeneral)
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

Color getColorForStatus(String status) {
  if (status == "เข้าเรียนปกติ") {
    return Colors.green; // สีเขียวสำหรับ "เข้าเรียนปกติ"
  } else if (status == "เข้าเรียนสาย") {
    return Colors.orange; // สีส้มสำหรับ "เข้าเรียนสาย"
  } else if (status == "ขาดเรียน") {
    return Colors.red; // สีแดงสำหรับ "ขาด"
  } else {
    return Colors.black; // สีดำหากไม่ระบุสี
  }
}
