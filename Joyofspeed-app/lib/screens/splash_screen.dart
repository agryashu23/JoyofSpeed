import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joy_of_speed/screens/agent_home_screen.dart';
import 'package:joy_of_speed/screens/agent_start_screen.dart';
import 'package:joy_of_speed/screens/client_start_screen.dart';
import 'package:joy_of_speed/screens/delivery_home_screen.dart';
import 'package:joy_of_speed/screens/delivery_start_screen.dart';
import 'package:joy_of_speed/screens/home_screen.dart';
import 'package:joy_of_speed/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString('loggedIn', 'true');
      // await prefs.setString('userID', '643d18b8f36a5a20fb545b67');
      // await prefs.setString('mobile', '7879180998');
      // await prefs.setString('name', 'Yashu Agarwal');
      // await prefs.setString('type', 'user');
      String? loginStatus = await prefs.getString('loggedIn') ?? 'false';
      String? accountType = await prefs.getString('type') ?? 'user';

      if (loginStatus == 'true') {
        if(accountType=='user'){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        }else if(accountType=='agent'){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AgentStartScreen();
          }));
        }else if(accountType=='client'){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ClientStartScreen();
          }));
        }
        else if(accountType=='delivery'){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DeliveryStartScreen();
          }));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200.w,
            height: 200.h,
            margin: EdgeInsets.only(left: 80.w),
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 80.w),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Joy Of Speed',
                  speed: Duration(milliseconds: 100),
                  textStyle: TextStyle(
                      fontFamily: 'espresso',
                      color: Color(0xff3b237b),
                      fontSize: 35.w,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
