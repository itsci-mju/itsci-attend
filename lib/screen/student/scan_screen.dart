import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobiletest2/controller/attendanceschedule_controller.dart';
import 'package:flutter_application_mobiletest2/controller/registration_controller.dart';
import 'package:flutter_application_mobiletest2/controller/user_controller.dart';
import 'package:flutter_application_mobiletest2/model/registration.dart';
import 'package:flutter_application_mobiletest2/model/user.dart';
import 'package:flutter_application_mobiletest2/screen/student/home_screen.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:quiver/testing/src/time/time.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class scanScreenForStudent extends StatefulWidget {
  const scanScreenForStudent({super.key});

  @override
  State<scanScreenForStudent> createState() => _scanScreenForStudentState();
}

class _scanScreenForStudentState extends State<scanScreenForStudent> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final UserController userController = UserController();
  final RegistrationController registrationController =
      RegistrationController();
  final AttendanceScheduleController attendanceScheduleController =
      AttendanceScheduleController();
  bool? isLoaded = false;
  Barcode? result;
  QRViewController? controller;
  String? scannedData;
  String? IdUser;
  String? regId;
  String? sectionId;
  String? weekNo;
  String? checkInTime;

  var DateNowCheck;
  String? startTime;
  String? checkInTimeForCal;
  var startTimeMinInt = 0.0;
  var checkTimeMinInt = 0.0;
  var timeResult;
  String? status;

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
        setState(() {
          isLoaded = true;
        });
      }
    }
  }

  void onQRViewCamera(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      splitData(scanData.code.toString());
      setState(() {
        result = scanData;
        scannedData =
            result != null ? result!.code : null; // ดึงข้อมูลจาก result
      });
      print("ลำดับ 4 ${scannedData} ${regId}");
      if (scannedData != null && regId != null) {
        //หาความต่างของเวลาเพื่อกำหนดสถานะ
        calculateTime(startTime!, checkInTimeForCal!);
        showScanSuccessDialog(context);
      } else {
        showScanUserNotInSectionDialog(context);
      }
    });
  }

  void calculateTime(String startTime, String checkInTime) {
    List<String> startTimeTrim = startTime.split('-');
    List<String> checkTimeTrim = checkInTime.split('-');

    startTimeMinInt = ((double.parse(startTimeTrim[0]) * 60) +
        double.parse(startTimeTrim[1]) +
        (double.parse(startTimeTrim[2]) / 60));
    checkTimeMinInt = ((double.parse(checkTimeTrim[0]) * 60) +
        double.parse(checkTimeTrim[1]) +
        (double.parse(checkTimeTrim[2]) / 60));

    //หา status
    timeResult = startTimeMinInt - checkTimeMinInt;
    if (timeResult >= 0 || (timeResult < 0 && timeResult >= -15)) {
      status = "เข้าเรียนปกติ";
    } else if (timeResult < -15 && timeResult >= -30) {
      status = "เข้าเรียนสาย";
    } else {
      status = "ขาดเรียน";
    }
    /*print("TestStartTimeMinInt ${startTimeMinInt}");
    print("TestCheckTimeMinInt ${checkTimeMinInt}");
    print("TestResult ${timeResult}");
    print("TestStatus ${status}");*/
  }

  Future<void> splitData(String data) async {
    print(data);
    print("ลำดับ 2 ");
    List<String> parts = data.split(','); // แยกข้อมูลด้วยตัวอักษร ":"
    if (parts.length >= 2) {
      List<String> sectionparts = parts[1].split(':');
      String sectionIdSplit = sectionparts[1].trim();

      List<String> startTimeparts = parts[2].split(':');
      String startTimeSplit = startTimeparts[1].trim();

      List<String> weekparts = parts[3].split(':');
      String weekNoSplit = weekparts[1].trim();

      sectionId = sectionIdSplit;
      startTime = startTimeSplit;
      weekNo = weekNoSplit;
      DateNowCheck = DateTime.now();
      checkInTimeForCal =
          DateFormat('HH-mm-ss').format(DateNowCheck).toString();
      checkInTime =
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateNowCheck).toString();
      // พิมพ์ค่าออกมา
      //print('Section: $section');
      //print('StartTime: $startTime');
      //print('Week: $week');
      //print( 'DateNow:${DateFormat('HH-mm-ss').format(DateTime.now()).toString()}');
    }
    //หาค่า Id ของ registration
    Registration? reg = await registrationController
        .get_RegistrationIdBySectionIdandIdUser(sectionId!, IdUser!);
    regId = reg!.id.toString();
    print("ลำดับ 3 ${regId}");
  }

  void showScanSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('สแกนสำเร็จ!'),
          //content: Text('ค่าที่ได้: $scannedData'),
          content: const Text('การสแกนเสร็จสิ้น'),
          actions: [
            TextButton(
                onPressed: () async {
                  controller!.pauseCamera();
                  // Add ลง Database
                  http.Response response =
                      await attendanceScheduleController.addAttendanceSchedule(
                          regId.toString(),
                          weekNo.toString(),
                          checkInTime.toString(),
                          status.toString());
                  if (response.statusCode == 200) {
                    print("บันทึกการเข้าเรียนสำเร็จ");
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const homeScreenForStudent();
                        },
                      ),
                    );
                  }
                },
                child: const Text('ตกลง')),
          ],
        );
      },
    );
  }

  void showScanUserNotInSectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('แจ้งเตือน!'),
          //content: Text('ค่าที่ได้: $scannedData'),
          content: const Text('คุณไม่ได้ลงทะเบียนเรียนรายวิชานี้'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const homeScreenForStudent();
                    },
                  ),
                );
              },
              child: const Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: onQRViewCamera,
            ),
          ),
          Expanded(
              child: Center(
            child: Column(children: [
              const SizedBox(height: 10), // ระยะห่างระหว่างข้อความและปุ่ม
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // กำหนดมุม
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        // ตรงนี้คุณสามารถกำหนดหน้าที่คุณต้องการแสดงหรือนำไปยังหน้าอื่น
                        return const homeScreenForStudent();
                      },
                    ),
                  );
                },
                child: const Text('กลับไปหน้าหลัก'),
              ),
            ]),
          ))
        ],
      ),
    );
  }
}
