import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/controller/section_controller.dart';
import 'package:flutter_application_mobiletest2/model/section.dart';
import 'package:flutter_application_mobiletest2/screen/teacher/list_class.dart';
import 'package:flutter_application_mobiletest2/screen/widget/drawer_teacher.dart';
import 'package:flutter_application_mobiletest2/screen/widget/mainTextStyle.dart';
import 'package:flutter_application_mobiletest2/screen/widget/my_abb_bar.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TeacherGenerateQR extends StatefulWidget {
  final String sectionId;
  const TeacherGenerateQR({super.key, required this.sectionId});

  @override
  State<TeacherGenerateQR> createState() => _TeacherGenerateQRState();
}

class _TeacherGenerateQRState extends State<TeacherGenerateQR> {
  final SectionController sectionController = SectionController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String qrData = 'Initial Data'; // ข้อมูล QR code ตั้งต้น
  String? selectedDropdownValue;
  String? formattedStartTime;
  int? sectionid;
  int countdown = 10;
  Timer? timer;
  Timer? timecountdown;
  bool showQRCode = false;
  bool? stop = false;
  bool? isLoaded;
  var startTimeForQR;

  Section? section;
  TextEditingController subjectid = TextEditingController();
  TextEditingController subjectName = TextEditingController();
  TextEditingController teacherFName = TextEditingController();
  TextEditingController teacherLName = TextEditingController();
  TextEditingController sectionNumber = TextEditingController();
  DateTime sectionTime = DateTime.now();
  TextEditingController room = TextEditingController();
  TextEditingController sectiontype = TextEditingController();
  TextEditingController building = TextEditingController();

  void setDataToText() {
    subjectid.text = section?.course?.subject?.subjectId ?? "";
    subjectName.text = section?.course?.subject?.subjectName ?? "";
    teacherFName.text = section?.user?.fname ?? "";
    teacherLName.text = section?.user?.lname ?? "";
    sectionNumber.text = section?.sectionNumber ?? "";
    building.text = section?.room?.building ?? "";
    sectionTime = DateFormat('HH:mm').parse(section?.startTime ?? "").toLocal();
    sectiontype.text = section?.type ?? "";
    room.text = section?.room?.roomName ?? "";
  }

  void fetchData(String sectionId) async {
    setState(() {
      isLoaded = false;
    });
    section = await sectionController.get_Section(sectionId);
    setDataToText();

    setState(() {
      startTimeForQR = section?.startTime;
      formattedStartTime = startTimeForQR?.replaceAll(':', '-');
      qrData =
          'DateScan:${DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()},TimeScan:${DateFormat('HH-mm-ss').format(DateTime.now()).toString()},Section:${section?.id},StartTime:$formattedStartTime';
      isLoaded = true;
    });
  }

  List<String> dropdownItems = [
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

  void onChangedDropdown(String? newValue) {
    setState(() {
      // Stop the existing countdown timer if it's running
      timecountdown?.cancel();
      QRCode?.cancel();
      selectedDropdownValue = newValue;
      showQRCode = true;
      // Start a new countdown timer
      startTimer();
      // Reset the QR code
      Qrcodereset();
      countdown = 30;
    });
  }

  // สร้าง QR code และเปลี่ยนข้อมูลทุก 30 วินาที
  void generateQRCode() {
    setState(() {
      qrData =
          'DateScan:${DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()},TimeScan:${DateFormat('HH-mm-ss').format(DateTime.now()).toString()},Section:${section?.id},StartTime:$formattedStartTime';
    });
  }

  Timer? QRCode;
  int? timeqrcode;
  void Qrcodereset() {
    if (stop == false) {
      QRCode = Timer.periodic(const Duration(seconds: 30), (QRCode) {
        generateQRCode();
        Qrcodereset();
      });
      print('QRCODE $timeqrcode');
    }
  }

  // เริ่มต้น Timer
  void startTimer() {
    if (stop == false) {
      timecountdown =
          Timer.periodic(const Duration(seconds: 1), (timecountdown) {
        setState(() {
          if (countdown > 1) {
            countdown--;
          } else {
            countdown = 30;
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fetchData(widget.sectionId);
    selectedDropdownValue = dropdownItems[0];
    setState(() {
      timeqrcode = countdown;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      /*appBar: kMyAppBar,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      endDrawer: const DrawerTeacherWidget(),*/
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
          : ListView(children: [
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(children: [
                    const Text("เลือกสัปดาห์เพื่อสร้าง QR Code",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("สัปดาห์ที่ ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
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
                              value: selectedDropdownValue,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                              icon: const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.keyboard_arrow_down),
                              ), // กำหนดไอคอนที่นี่
                              iconSize: 24, // ขนาดของไอคอน
                              iconEnabledColor: Colors.black,
                              onChanged: onChangedDropdown,
                              items: dropdownItems
                                  .map<DropdownMenuItem<String>>((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20), // ใส่ Padding ทางซ้าย
                                    child: Text(
                                      item,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              }).toList(),
                              underline: const SizedBox(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: buildQRCodeWidget(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 200, // กำหนดความกว้างของปุ่ม
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: maincolor, // กำหนดสีพื้นหลังของปุ่ม
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20.0), // กำหนดมุม
                          ),
                        ),
                        onPressed: () async {
                          await Future.delayed(Duration
                              .zero); // รอเวลาเล็กน้อยก่อนไปหน้า DetailRoomScreen
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return const ListClassTeacherScreen();
                          }));
                        },
                        child: const Text("กลับหน้ารายวิชา",
                            style: CustomTextStyle.TextGeneral),
                      ),
                    ),
                  ]),
                ),
              )
            ]),
    );
  }

  Widget buildQRCodeWidget() {
    if (showQRCode) {
      return Column(
        children: [
          Center(
            child: QrImage(
              data: qrData +
                  ",Week:" +
                  selectedDropdownValue.toString(), // ข้อมูล QR code
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          Center(
            child: Text(
              'Countdown: ${countdown} seconds',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox
          .shrink(); // ถ้าไม่ควรแสดง QRCODE ให้ใช้ SizedBox.shrink() เพื่อซ่อน
    }
  }
}
