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
  List<Map<String, dynamic>> filterSemesterData = [];
  List<Map<String, dynamic>> filterTermData = [];
  bool? isLoaded = false;
  String? IdUser;
  String? sectionId;
  List<Registration>? registration;
  List<Section>? section;
  late List<bool> isMark1ClickedList;
  String? selectedSemester;
  List<String> semesters = ['ทั้งหมด'];
  String? selectedTerm;
  List<String> terms = ['ทั้งหมด', '1', '2'];

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    //String? username = "Tanakorn63@gmail.com";

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
                    'semester': sec.course?.semester,
                    'term': sec.course?.term,
                  })
              .toList();
          isMark1ClickedList = List.generate(data.length, (index) => false);
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
                    padding: const EdgeInsets.only(top: 10),
                    children: <Widget>[
                      Column(
                        children: [
                          for (var index = 0;
                              index < filterTermData.length;
                              index++)
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                      style: CustomTextStyle
                                                          .TextGeneral,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                    style: CustomTextStyle
                                                        .TextGeneral,
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
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors
                                                              .white, // กำหนดสีพื้นหลังของปุ่ม
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0), // กำหนดมุม
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                                  MaterialPageRoute(builder:
                                                                      (BuildContext
                                                                          context) {
                                                            return TeacherGenerateQR(
                                                                sectionId: data[
                                                                            index]
                                                                        ['id']
                                                                    .toString());
                                                          }));
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .qr_code_outlined,
                                                              size: 30,
                                                              color: Color
                                                                  .fromARGB(255,
                                                                      0, 0, 0),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text("คิวอาร์โค้ด",
                                                                style: CustomTextStyle
                                                                    .createFontStyle),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Container(
                                                      width: 300,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors
                                                              .white, // กำหนดสีพื้นหลังของปุ่ม
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0), // กำหนดมุม
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                                  MaterialPageRoute(builder:
                                                                      (BuildContext
                                                                          context) {
                                                            return AttendanceTeacherScreen(
                                                                sectionId: data[
                                                                            index]
                                                                        ['id']
                                                                    .toString());
                                                          }));
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .inventory_outlined,
                                                              size: 30,
                                                              color: Color
                                                                  .fromARGB(255,
                                                                      0, 0, 0),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text("การเข้าเรียน",
                                                                style: CustomTextStyle
                                                                    .createFontStyle),
                                                          ],
                                                        ),
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
                ),
              ],
            ),
    );
  }
}
