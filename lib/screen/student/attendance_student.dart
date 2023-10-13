import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/controller/attendanceschedule_controller.dart';
import 'package:flutter_application_mobiletest2/model/attendanceSchedule.dart';
import 'package:flutter_application_mobiletest2/screen/widget/drawer_student.dart';
import 'package:flutter_application_mobiletest2/screen/widget/mainTextStyle.dart';
import 'package:flutter_application_mobiletest2/screen/widget/my_abb_bar.dart';

class AttendanceStudentScreen extends StatefulWidget {
  final String regId;
  const AttendanceStudentScreen({super.key, required this.regId});

  @override
  State<AttendanceStudentScreen> createState() =>
      _AttendanceStudentScreenState();
}

class _AttendanceStudentScreenState extends State<AttendanceStudentScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final AttendanceScheduleController attendanceScheduleController =
      AttendanceScheduleController();
  List<Map<String, dynamic>> dataAtten = [];
  List<Map<String, dynamic>> dataReg = [];
  bool? isLoaded = false;
  List<AttendanceSchedule>? attendance;

  void setRegData(String regId) async {
    List<AttendanceSchedule> atten = await attendanceScheduleController
        .listAttendanceScheduleByRegistrationId(regId);

    setState(() {
      attendance = atten;
      dataReg = atten
          .map((atten) => {
                'id': atten.id ?? "",
                'registration_id': atten.registration?.id ?? "",
                'subjectid':
                    atten.registration?.section?.course?.subject?.subjectId ??
                        "",
                'userid': atten.registration?.user?.userid ?? "",
                'weekNo': atten.weekNo ?? "",
                'checkInTime': atten.checkInTime ?? "",
                'status': atten.status ?? "",
              })
          .toList();
      isLoaded = true;
    });
  }

  void showAtten(String week) async {
    List<AttendanceSchedule> atten =
        await attendanceScheduleController.listAttendanceScheduleByWeek(week);

    setState(() {
      attendance = atten;
      dataAtten = atten
          .map((atten) => {
                'subjectid':
                    atten.registration?.section?.course?.subject?.subjectId ??
                        "",
                'userid': atten.registration?.user?.userid ?? "",
                'checkInTime': atten.checkInTime ?? "",
                'status': atten.status ?? "",
              })
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    setRegData(widget.regId);
    showAtten(weekNum);
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
      endDrawer: const DrawerStudentWidget(),
      body: ListView(children: <Widget>[
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            const Text(
              "การเข้าเรียน",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 150,
              height: 50,
              alignment: Alignment.center,
              child: Card(
                elevation: 10,
                color: Color.fromARGB(255, 226, 226, 226),
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
                        right: 20), // กำหนดการเว้นระหว่างไอคอนและเนื้อหาที่นี่
                    child: Icon(Icons.keyboard_arrow_down),
                  ), // กำหนดไอคอนที่นี่
                  iconSize: 24, // ขนาดของไอคอน
                  iconEnabledColor: Colors.black,
                  // สีของไอคอน
                  items: weekNumItems.map(
                    (String weekNumItems) {
                      return DropdownMenuItem(
                        value: weekNumItems,
                        child: Center(
                          child: Text(
                            "WeeK $weekNumItems",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      weekNum = newValue!;
                    });
                  },
                  underline: const SizedBox(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: dataReg.map((item) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text("วิชา: ${item['subjectid']}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("รหัสนักศึกษา: ${item['userid']}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("เวลาเข้าเรียน: ${item['checkInTime']}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("สถานะ: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                            "${item['status']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getColorForStatus(item['status']),
                            ),
                          )
                        ],
                      ),
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
