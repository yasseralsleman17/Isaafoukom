import 'package:flutter/material.dart';
import 'package:isaafoukom/Admin/adminhomepage.dart';
import 'package:isaafoukom/authintication/Login/login_screen.dart';
import 'package:isaafoukom/authintication/Signup/signup_screen.dart';

import '../chatboot.dart';
import '../mapscreen.dart';

class WelcomeScreen extends StatefulWidget {




  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        color: Colors.blue.withOpacity(0.1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: size.width,
                child: Image.asset(
                  "assets/images/first_aid.png",
                  height: size.height * 0.45,
                  width: size.width,
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
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white),
                    ),
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
                    onPressed: () {
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
                      "SIGN UP",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    color :Color(0xFFF54141),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Mapscreen(report: "emergency",);
                          },
                        ),
                      );
                    },

                    child: Text(
                      "Send emergency call",
                      style: TextStyle(
                          color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    color :Color(0xFF2A66EC),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Chatboot();
                          },
                        ),
                      );
                    },

                    child: Text(
                      "Get medical advice",
                      style: TextStyle(
                          color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}