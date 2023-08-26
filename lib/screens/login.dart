import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/login_controller.dart';
import 'package:flutter_application_1/controller/user_controller.dart';
import 'package:flutter_application_1/model/login.dart';
import 'package:flutter_application_1/screens/admin/add_room.dart';
import 'package:flutter_application_1/screens/student/view_student_subject.dart';
import 'package:flutter_application_1/screens/teacher/view_subject.dart';
import 'package:http/http.dart' as http;

import '../color.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<LoginScreen>{

  bool? isLoaded = false;
  bool passToggle = true;
  Login? logins;

  final _formfield = GlobalKey<FormState>();
  final LoginController loginController = LoginController();
  final UserController userController = UserController();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passworldController = TextEditingController();
  
  void fetchData () async {
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: maincolor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 60),
          child: Form(
            key: _formfield,
            child: Card(
              elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 600,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage("images/mjuicon.png"),
                              height: 200,
                              width: 200,
                            ),
                            SizedBox(height: 50),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: "Username",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                                
                              ),
                              validator: (value){
                                //ถ้าใส่ email ถูก
                                bool usernameValid = RegExp(
                                  //ตรวจเช็ค email
                                  //r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  //ตรวจเช็ค username
                                  r"^[MJU]+[0-9]")
                                  .hasMatch(value!); 
                      
                                //กรณีไม่ใส่ username
                                if (value.isEmpty){
                                  return"Enter Username";
                                }
                                //กรณีใส่ usename ผิด  
                                else if(!usernameValid){
                                  return"Username Must be MJUรหัสนักศึกษา";
                                }                
                              },
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: passworldController,
                              obscureText: passToggle,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: InkWell(
                                  onTap: (){
                                    setState(() {
                                      passToggle = !passToggle;
                      
                                    });
                                  },
                                  child: Icon(passToggle ? Icons.visibility :Icons.visibility_off),             
                                )
                              ),
                              validator: (value){

                                bool passwordValid = RegExp(
                                  //ตรวจเช็ค email
                                  //r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  //ตรวจเช็ค username
                                  r"^[MJU]+@+[0-9]")
                                  .hasMatch(value!); 
                                //กรณีไม่ใส่ Password
                                if (value.isEmpty){
                                  return"Enter Password";
                                }
                                //กรณีใส่ Password ผิด   
                                else if(!passwordValid){
                                  return"Password Must be MJU@วันเดือนปีเกิดของนักศึกษา";
                                }
                              },
                            ),
                            SizedBox(height: 35,),                         
                            InkWell(
                              onTap: () async {
                                if(_formfield.currentState!.validate()){
                                  print("Data Added Successfully");

                                  http.Response response = await loginController.doLogin(usernameController.text, passworldController.text);

                                  if (response.statusCode == 200){
                                    print("ผ่าน");

                                    //Check Role for Go Screen
                                    var jsonResponse = jsonDecode(response.body);
                                    List<dynamic> roles = jsonResponse['Role']; 
                                    String roleName = roles[1]['role'];
                                    if (roleName == "Student"){
                                      Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (BuildContext context){
                                          return const ViewStudentSubject();}
                                      ));
                                    }else if (roleName == "Teacher"){
                                      Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (BuildContext context){
                                          return const subjectScreen();}
                                      ));
                                    }else if (roleName == "Admin"){
                                      Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (BuildContext context){
                                          return const AddRoomScreen();}
                                      ));
                                    }
                                  }else if(response.statusCode == 409){
                                    print("ไม่เจอข้อมูล");
                                  }else{
                                    print("Error");
                                  }
                                  usernameController.clear();
                                  passworldController.clear();

                                }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: maincolor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    "Log In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }

}