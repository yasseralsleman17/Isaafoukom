import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isaafoukom/Admin/adminhomepage.dart';
import 'package:isaafoukom/authintication/Signup/signup_screen.dart';
import 'package:http/http.dart' as http;

import 'package:email_validator/email_validator.dart';

import '../../Paramedics/paramedics_home_page.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();
  }

  log_in() async {

    var request = http.MultipartRequest(
       'POST', Uri.parse(APIA+'login'));
    request.fields.addAll({'email': email, 'password': password});

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      var responseData =
          json.decode(await response.stream.bytesToString())['data'];
      if (responseData['type'] == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Adminhomepage();
            },
          ),
        );
      } else if (responseData['type'] == 3) {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ParamedicsHomePage(id:responseData["id"].toString());
            },
          ),
        );


      }
    } else {
      print(response.reasonPhrase);
    }
  }

  bool isPasswordValid(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r"[a-z]"))) return false;
    if (!password.contains(RegExp(r"[A-Z]"))) return false;
    if (!password.contains(RegExp(r"[0-9]"))) return false;
    return true;
  }

  bool showpassword = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Colors.blue.withOpacity(0.1),
        width: double.infinity,
        height: size.height,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/login.png",
                  height: size.height * 0.45,
                  width: size.width,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Color(0xFF98CDF6),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: TextFormField(
                    validator: (val) => EmailValidator.validate(val)
                        ? null
                        : "Please enter a valid email",
                    onChanged: (value) {
                      setState(() {
                        email = value;
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                    onChanged: (value) {
                      setState(() {
                        password = value;
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
                  width: size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: FlatButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      color: Color(0xFF2A66EC),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          log_in();
                        }
                      },
                      child: Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Card(
                  margin: EdgeInsets.fromLTRB(
                      size.height * 0.08, 0, size.height * 0.08, 0),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "Don’t have an Account ?",
                          style: TextStyle(color: Color(0xFF2A66EC)),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignUpScreen();
                                },
                              ),
                            );
                          },
                          child: Text(
                            "Sign Up",
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
