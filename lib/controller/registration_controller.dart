import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_application_mobiletest2/model/registration.dart';
import 'package:http/http.dart' as http;
import '../ws_config.dart';

class RegistrationController {
  Future upload(Uint8List file, String? filename, String id) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        file,
        filename: filename,
        // Provide the desired file name and extension
      ),
      'id': id
    });
    String url = baseURL + '/registrations/upload';

    Response response = await dio.post(url, data: formData);

    print("Student : " + response.data);
    return response.statusCode;
  }
/*
  Future get_ViewSubject(String id) async {
    var url = Uri.parse(baseURL + '/registrations/stu_listsubject' + id);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Registration> list = jsonResponse
        .map((e) => Registration.formJsonToRegistration(e))
        .toList();
    //print(list);
    return list;
  }
*/

  Future get_ViewSubject(String id) async {
    var url = Uri.parse(baseURL + '/registrations/stu_listsubject/' + id);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    //var jsonResponse = json.decode(utf8Body);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Registration> list = jsonResponse
        .map((e) => Registration.formJsonToRegistration(e))
        .toList();
    print(list);
    return list;
  }
}
