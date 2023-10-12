import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_mobiletest2/controller/registration_controller.dart';
import 'package:flutter_application_mobiletest2/controller/user_controller.dart';
import 'package:flutter_application_mobiletest2/model/registration.dart';
import 'package:flutter_application_mobiletest2/model/user.dart';
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
  bool? isLoaded = false;
  List<Registration>? registration;
  String? IdUser;

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    //print(username);
    if (username != null) {
      User? user = await userController.get_UserByUsername(username);
      print(user?.id);
      if (user != null) {
        IdUser = user.id.toString();
        print(IdUser);
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
                  })
              .toList();
          isLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
