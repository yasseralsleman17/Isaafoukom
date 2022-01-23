import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:isaafoukom/Admin/adminhomepage.dart';
import 'package:isaafoukom/Paramedics/paramedics_home_page.dart';
import 'package:isaafoukom/authintication/Login/login_screen.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key key,
  }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String account_type = "2";
  String first_name, last_name;
  String email;
  String password;

  @override
  void initState() {
    super.initState();
  }

  bool showpassword = true;

  @override
  Widget build(BuildContext context) {


    sign_up() async {
      var headers = {
        'Authorization': 'Bearer 2|EDODmK2oqyb9HQ6CW1G3lhuzfR0DHZYt5Xx47qGr'
      };
     var request = http.MultipartRequest(
          'POST', Uri.parse(APIA+'register'));
      request.fields.addAll({
        'fname': first_name,
        'lname': last_name,
        'username': first_name + " " + last_name,
        'email': email,
        'password': password,
        'type': account_type
      });
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseData =
        json.decode(await response.stream.bytesToString())['data'];
        print(responseData);
        if(account_type=="2")

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Adminhomepage();
            },
          ),
        );
        if(account_type=="3")

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen();
            },
          ),
        );
      } else {
        print(response.reasonPhrase);
        print(response.request);
      }
    }

    bool isPasswordValid(String password) {
      if (password.length < 8) return false;
      if (!password.contains(RegExp(r"[a-z]"))) return false;
      if (!password.contains(RegExp(r"[A-Z]"))) return false;
      if (!password.contains(RegExp(r"[0-9]"))) return false;
      return true;
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        color: Colors.blue.withOpacity(0.1),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/stethoscope.png",
                  height: size.height * 0.25,
                  width: size.width,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Color(0xFF98CDF6),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: TextFormField(
                    validator: (val) =>
                        val.isEmpty ? 'Enter your first name' : null,
                    onChanged: (val) {
                      setState(() {
                        first_name = val;
                      });
                    },
                    cursorColor: Color(0xFF2A66EC),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Color(0xFF2A66EC),
                      ),
                      hintText: "first name",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Color(0xFF98CDF6),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: TextFormField(
                    validator: (val) =>
                        val.isEmpty ? 'Enter your last name' : null,
                    onChanged: (val) {
                      setState(() {
                        last_name = val;
                      });
                    },
                    cursorColor: Color(0xFF2A66EC),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Color(0xFF2A66EC),
                      ),
                      hintText: "last name",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Color(0xFF98CDF6),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: TextFormField(
                    validator: (val) => EmailValidator.validate(val)
                        ? null
                        : "Please enter a valid email",
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    cursorColor: Color(0xFF2A66EC),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Color(0xFF2A66EC),
                      ),
                      hintText: "Your Email",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Color(0xFF98CDF6),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: TextFormField(
                    validator: (val) => !isPasswordValid(val)
                        ? 'Enter a Vailed password\n'
                            'at least 8 chars contain [ a-z A-Z 0-9 ]!!'
                        : null,
                    obscureText: showpassword,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    cursorColor: Color(0xFF2A66EC),
                    decoration: InputDecoration(
                      hintText: "Password!",
                      icon: Icon(
                        Icons.lock,
                        color: Color(0xFF2A66EC),
                      ),
                      suffixIcon: Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.visibility,
                            color: Color(0xFF2A66EC),
                          ),
                          onPressed: () {
                            setState(() {
                              showpassword = !showpassword;
                            });
                          },
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Color(0xFF98CDF6),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Account type",
                        style: TextStyle(fontSize: 18, color: Colors.brown),
                      ),
                      DropdownButton(
                          hint: Text("Account type"),
                          onChanged: (val) {
                            setState(() {
                              account_type = val;
                            });
                          },
                          value: account_type,
                          items: [
                       /*     DropdownMenuItem(
                                value: '1',
                                child: Text("Patient",
                                    style: TextStyle(color: Colors.black))),*/
                            DropdownMenuItem(
                                value: '3',
                                child: Text("Paramedics",
                                    style: TextStyle(color: Colors.black))),
                            DropdownMenuItem(
                                value: '2',
                                child: Text("Admin",
                                    style: TextStyle(color: Colors.black))),
                          ]),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      color: Color(0xFF2A66EC),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          sign_up();
                        }
                      },
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.fromLTRB(
                      size.height * 0.08, 0, size.height * 0.08, 0),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "Already have an Account ?",
                          style: TextStyle(color: Color(0xFF2A66EC)),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return LoginScreen();
                                },
                              ),
                            );
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              color: Color(0xFF2A66EC),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
