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
  List<AttendanceSchedule>? attendance;
  int? weekNumCheck = 1;
  String? type;
  String? checkInTime;
  String? userid;
  String? subjectid;
  String? subjectName;
  String? statusCheck;
  String? formattedTime;
  bool checkInTimeandType = false;
  bool? isLoaded = false;

  void showAtten(String regId) async {
    List<AttendanceSchedule> atten = await attendanceScheduleController
        .listAttendanceScheduleByRegistrationId(regId);
    setState(() {
      attendance = atten;
      data = atten
          .map((atten) => {
                'subjectid':
                    atten.registration?.section?.course?.subject?.subjectId ??
                        "",
                'subjectName':
                    atten.registration?.section?.course?.subject?.subjectName ??
                        "",
                'userid': atten.registration?.user?.userid ?? "",
                'weekNo': atten.weekNo ?? "",
                'checkInTime': atten.checkInTime ?? "",
                'status': atten.status ?? "",
                'type': atten.registration?.section?.type ?? "",
              })
          .toList();
      userid = data.isNotEmpty ? data[0]['userid'] : null;
      subjectid = data.isNotEmpty ? data[0]['subjectid'] : null;
      subjectName = data.isNotEmpty ? data[0]['subjectName'] : null;
      statusCheck = data.isNotEmpty ? data[0]['status'] : null;
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
    showAtten(widget.regId);
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
          : ListView(children: <Widget>[
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: maincolor,
                      //color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        AttenHeader(),
                      ],
                    ), // ปรับความกว้างของ Container ตามขนาดของหน้าจอ
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: List<Widget>.generate(15, (week) {
                      final weekNumber = week + 1;
                      final weekText = 'สัปดาห์ $weekNumber';
                      final hasDataForWeek =
                          data.any((item) => item['weekNo'] == weekNumber);
                      if (hasDataForWeek) {
                        // หาสถานะของแต่ละสัปดาห์
                        final weekStatus = data
                            .firstWhere((item) => item['weekNo'] == weekNumber);
                        final status = weekStatus['status'];
                        // กำหนดค่า statusCheck ตามสถานะของสัปดาห์นี้
                        statusCheck = status;

                        // หาเวลาของแต่ละสัปดาห์
                        final weekcheckInTime = data
                            .firstWhere((item) => item['weekNo'] == weekNumber);
                        if (weekcheckInTime != null) {
                          final findCheckInTime =
                              DateTime.parse(weekcheckInTime['checkInTime'])
                                  .toLocal();
                          final timeFormatter = DateFormat('HH:mm:ss');
                          formattedTime = timeFormatter.format(findCheckInTime);
                        }
                      }

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

                      if (hasDataForWeek) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(weekText,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const Text(" สถานะ: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              Icon(
                                iconData,
                                color: iconColor,
                              ),
                              Text(" เวลา: $formattedTime",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(weekText,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const Text(" สถานะ: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const Icon(
                                Icons.info,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                  ),
                ],
              )
            ]),
    );
  }

  // ignore: non_constant_identifier_names
  Widget AttenHeader() {
    if (checkInTimeandType) {
      return Column(
        children: [
          const Text("การเข้าเรียน", style: CustomTextStyle.TextGeneral),
          const SizedBox(
            height: 5,
          ),
          Text("รหัสนักศึกษา: ${userid ?? ""}",
              style: CustomTextStyle.TextGeneral),
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
