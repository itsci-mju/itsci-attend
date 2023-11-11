import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobiletest2/color.dart';
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

import '../../model/attendanceSchedule.dart';

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
  String? status;
  bool qrExpire = true;
  Registration? reg;
  var DateNowCheck;
  String? startTime;
  String? checkInTimeForCal;
  var startTimeMinInt = 0.0;
  var checkTimeMinInt = 0.0;
  var timeGenQRSecondsInt = 0.0;
  var checkTimeSecondsInt = 0.0;
  var timeResult;

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

  Future<void> splitData(String data) async {
    print(data);
    print("ลำดับ 2 ");
    List<String> parts = data.split(','); // แยกข้อมูลด้วยตัวอักษร ":"
    if (parts.length >= 2) {
      List<String> dateTimeparts = parts[0].split(':');
      String dateTimeSplit = dateTimeparts[1].trim(); //
      //print('dateTimeSplit : $dateTimeSplit');
      //print('dateNow : ${DateFormat('dd-MM-yyyy').format(DateTime.now())}');

      List<String> timeTimeparts = parts[1].split(':');
      String timeTimeSplit = timeTimeparts[1].trim(); //
      //print('timeTimeSplit : $timeTimeSplit');
      //print('timeNow : ${DateFormat('HH-mm-ss').format(DateTime.now())}');

      List<String> sectionparts = parts[2].split(':');
      String sectionIdSplit = sectionparts[1].trim();

      List<String> startTimeparts = parts[3].split(':');
      String startTimeSplit = startTimeparts[1].trim();

      List<String> weekparts = parts[4].split(':');
      String weekNoSplit = weekparts[1].trim();

      List<String> timelimitparts = parts[5].split(':');
      String timelimitSplit = timelimitparts[1].trim();

      sectionId = sectionIdSplit;
      startTime = startTimeSplit;
      weekNo = weekNoSplit;
      DateNowCheck = DateTime.now();
      String checkInDateForCal =
          DateFormat('dd-MM-yyyy').format(DateNowCheck).toString();
      checkInTimeForCal =
          DateFormat('HH-mm-ss').format(DateNowCheck).toString();
      checkInTime =
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateNowCheck).toString();
      qrCheckExpire(dateTimeSplit, checkInDateForCal, timeTimeSplit,
          checkInTimeForCal!, timelimitSplit);
      // พิมพ์ค่าออกมา
      //print('Section: $section');
      //print('StartTime: $startTime');
      //print('Week: $week');
      //print( 'DateNow:${DateFormat('HH-mm-ss').format(DateTime.now()).toString()}');
    }
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

  Future<bool> isUserAlreadyScanned(String regId, String weekNo) async {
    // สอบถามรายการเช็คชื่อเพื่อตรวจสอบว่าผู้ใช้ได้ถูกสแกนไปแล้วสำหรับ regId และ weekNo ที่ระบุ
    // คุณสามารถใช้ attendanceScheduleController เพื่อสอบถามรายการ
    // หากมีรายการอยู่ ให้ส่งค่าเป็น true; มิฉะนั้นส่งค่าเป็น false
    AttendanceSchedule? existingRecord =
        await attendanceScheduleController.getAttendanceRecord(regId, weekNo);
    return existingRecord != null;
  }

  void qrCheckExpire(String dateGenQR, String checkInDate, String timeGenQR,
      String checkInTime, String timeLimit) {
    List<String> timeGenQRTrim = timeGenQR.split('-');
    List<String> checkTimeTrim = checkInTime.split('-');

    timeGenQRSecondsInt = (double.parse(timeGenQRTrim[0]) * 3600) +
        (double.parse(timeGenQRTrim[1]) * 60) +
        double.parse(timeGenQRTrim[2]);
    checkTimeSecondsInt = (double.parse(checkTimeTrim[0]) * 3600) +
        (double.parse(checkTimeTrim[1]) * 60) +
        double.parse(checkTimeTrim[2]);

    //หา QR หมดอายุหรือยัง
    timeResult = checkTimeSecondsInt - timeGenQRSecondsInt;
    if (dateGenQR == checkInDate && timeResult <= int.parse(timeLimit)) {
      qrExpire = false;
    }
    /*print("TestDateGenQR ${dateGenQR}");
    print("TestcheckInDate ${checkInDate}");
    print("TestTimeLimit ${int.parse(timeLimit)}");
    print("TestCheckTimeMinInt ${checkTimeSecondsInt}");
    print("TestTimeGenQRMinInt ${timeGenQRSecondsInt}");
    print("TestResult ${timeResult}");
    print("TestStatus ${status}");*/
  }

  void onQRViewCamera(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
        scannedData =
            result != null ? result!.code : null; // ดึงข้อมูลจาก result
      });
      splitData(scanData.code.toString());
      if (scannedData != null && regId != null) {
        if (await isUserAlreadyScanned(regId!, weekNo!)) {
          showUserAleadyScannedDialog(
              context); // ผู้ใช้ถูกสแกนไปแล้ว แสดงไดอะล็อก
        } else if (qrExpire == false) {
          qrExpire = true;
          calculateTime(startTime!, checkInTimeForCal!);
          showScanSuccessDialog(context);
        } else {
          showQRCodeExpireDialog(context);
        }
      } else {
        showScanUserNotInSectionDialog(context);
      }
      reg = await registrationController.get_RegistrationIdBySectionIdandIdUser(
          sectionId!, IdUser!);
      regId = reg!.id.toString();
    });
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
                controller!.pauseCamera();
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

  void showUserAleadyScannedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('แจ้งเตือน!'),
          //content: Text('ค่าที่ได้: $scannedData'),
          content: const Text('สัปดาห์นี้คุณได้ทำการสแกนไปแล้ว'),
          actions: [
            TextButton(
              onPressed: () async {
                controller!.pauseCamera();
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

  void showQRCodeExpireDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('แจ้งเตือน!'),
          //content: Text('ค่าที่ได้: $scannedData'),
          content: const Text('QR Code หมดอายุแล้ว!'),
          actions: [
            TextButton(
              onPressed: () async {
                controller!.pauseCamera();
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
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: const EdgeInsets.all(20.0), // ระยะห่างรอบตัวแสกน
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue, // สีเส้นขอบ
                        width: 2.0, // ความหนาขอบ
                      ),
                    ),
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: onQRViewCamera,
                      overlay: QrScannerOverlayShape(
                        borderColor: Colors.blue, // สีขอบของตัวแสกน
                        borderRadius: 10, // รัศมีขอบของตัวแสกน
                        borderLength: 30, // ความยาวขอบของตัวแสกน
                        borderWidth: 10, // ความหนาขอบของตัวแสกน
                        cutOutSize: 250, // ขนาดของหน้าแสดง QR code
                      ),
                    ),
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
