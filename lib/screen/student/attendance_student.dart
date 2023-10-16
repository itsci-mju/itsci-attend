import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/controller/attendanceschedule_controller.dart';
import 'package:flutter_application_mobiletest2/model/attendanceSchedule.dart';
import 'package:flutter_application_mobiletest2/screen/widget/drawer_student.dart';
import 'package:flutter_application_mobiletest2/screen/widget/mainTextStyle.dart';
import 'package:flutter_application_mobiletest2/screen/widget/my_abb_bar.dart';
import 'package:intl/intl.dart';

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
  List<Map<String, dynamic>> data = [];
  bool? isLoaded = false;
  List<AttendanceSchedule>? attendance;
  int? weekNoCheck = 1;
  String? type;
  String? checkInTime;
  bool checkInTimeandType = false;

  void showAtten(String regId, int weekNoCheck) async {
    List<AttendanceSchedule> atten = await attendanceScheduleController
        .listAttendanceScheduleByRegistrationId(regId);

    setState(() {
      attendance = atten;
      data = atten
          .where((atten) => atten.weekNo == weekNoCheck)
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
    showAtten(widget.regId, weekNoCheck!);
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
                  const Text("การเข้าเรียน",
                      style: CustomTextStyle.TextGeneral),
                  const SizedBox(
                    height: 5,
                  ),
                  TimeAndType(),
                  const SizedBox(
                    height: 5,
                  ),
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
                            // สีของไอคอน
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
                                showAtten(widget.regId, int.parse(weekNum));
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("สถานะ: ",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("เวลาเข้าเรียน: $formattedTime",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
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

  // ignore: non_constant_identifier_names
  Widget TimeAndType() {
    if (checkInTimeandType) {
      return Column(
        children: [
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
