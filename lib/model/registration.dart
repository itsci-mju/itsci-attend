import 'package:flutter_application_mobiletest2/model/login.dart';
import 'package:flutter_application_mobiletest2/model/section.dart';
import 'package:flutter_application_mobiletest2/model/user.dart';

class Registration {
  int? id;

  Section? section;
  User? user;

  // เปลี่ยนประเภทของ loginid เป็น Login

  Registration({
    this.id,
    this.section,
    this.user,
  });

  Map<String, dynamic> formRegistrationToJson() {
    return <String, dynamic>{
      'id': id,
      'section': section?.formSectionToJson(),
      'user': user?.formUserToJson(),
    };
  }

  factory Registration.formJsonToRegistration(Map<String, dynamic> json) {
    return Registration(
      id: json["id"],
      section: Section.formJsonToSection(json["section"]),
      user: User.formJsonToUser(json["user"]),
    );
  }
}
