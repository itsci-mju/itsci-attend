import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/color.dart';
import 'package:flutter_application_mobiletest2/controller/user_controller.dart';
import 'package:flutter_application_mobiletest2/model/user.dart';
import 'package:flutter_application_mobiletest2/screen/widget/drawer_student.dart';
import 'package:flutter_application_mobiletest2/screen/widget/my_abb_bar.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class EditStudentPassword extends StatefulWidget {
  final String id;
  const EditStudentPassword({super.key, required this.id});

  @override
  State<EditStudentPassword> createState() => _EditStudentPasswordState();
}

class _EditStudentPasswordState extends State<EditStudentPassword> {
  TextEditingController passwordController = TextEditingController();
  final UserController userController = UserController();
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();
  bool? isLoaded = false;
  bool passToggle = true;
  User? user;
  String? IdUser;

  void userData(String id) async {
    user = await userController.get_Userid(id);
    setState(() {
      IdUser = id.toString();
      isLoaded = false;
    });
  }

  @override
  void initState() {
    super.initState();
    userData(widget.id);
  }

  void showSuccessToChangeUserAlert() {
    QuickAlert.show(
      context: context,
      title: "การแก้สำเร็จ",
      text: "ข้อมูลถูกแก้ไขเรียบร้อยแล้ว",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      onConfirmBtnTap: () {
        // ทำการนำทางไปยังหน้าใหม่ที่คุณต้องการ
        /*Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const EditProfileTeacherScreen(),
          ),
        );*/
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kMyAppBar,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      endDrawer: const DrawerStudentWidget(),
      body: Form(
        key: _formfield,
        child: Column(children: [
          Center(
            child: Column(children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              Icon(
                Icons.person,
                size: 100,
                color: maincolor,
              ),
            ]),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
                decoration: BoxDecoration(
                  //color: maincolor,
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(50),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
