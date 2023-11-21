import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joy_of_speed/screens/agent_home_screen.dart';
import 'package:joy_of_speed/screens/agent_start_screen.dart';
import 'package:joy_of_speed/screens/client_start_screen.dart';
import 'package:joy_of_speed/screens/delivery_home_screen.dart';
import 'package:joy_of_speed/screens/delivery_start_screen.dart';
import 'package:joy_of_speed/screens/home_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginOTPScreen extends StatefulWidget {
  const LoginOTPScreen(
      {Key? key,
      required this.choice,
      required this.verificationId,
      required this.phone})
      : super(key: key);

  final String choice;
  final String verificationId;
  final String phone;

  @override
  State<LoginOTPScreen> createState() => _LoginOTPScreenState();
}

class _LoginOTPScreenState extends State<LoginOTPScreen> {
  String code = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   backgroundColor: Color(0xfff6ab36),
      //   toolbarHeight: 50.h,
      //   bottomOpacity: 0.7,
      //   title: Text("Login", style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontSize: 26.w,
      //       color: Colors.white,
      //       letterSpacing: 1),)
      // ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.h),
            height: 250.h,
            child: Center(
              child: Lottie.asset(
                "assets/lottieFiles/delivery_truck.json",
                repeat: true,
                reverse: true,
                animate: true,
                frameRate: FrameRate(30),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 360.w,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              margin: EdgeInsets.only(top: 50.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xfff6ab36).withOpacity(0.4),
                      Color(0xfff6ab36).withOpacity(0.8),
                    ]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Center(
                    child: Text(
                      "Enter otp send to Mobile No-",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.brown,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Text(
                        " +91 ${widget.phone}",
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                  OtpTextField(
                    numberOfFields: 6,
                    enabledBorderColor: Colors.white,
                    textStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.w),
                    //set to true to show as box or false to show as dash
                    showFieldAsBox: true,
                    //runs when a code is typed in
                    fieldWidth: 47.w,

                    keyboardType: TextInputType.number,
                    fillColor: Colors.white,
                    borderRadius: BorderRadius.circular(10),

                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                    ),

                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) {
                      setState(() {
                        code = verificationCode;
                      });
                      print(code);
                    }, // end onSubmit
                  ),
                  GestureDetector(
                    onTap: () {
                      // change UserStart to AgentHome or DeliveryStart to get int o different pages
                      // Navigator.pushAndRemoveUntil(context,
                      //     MaterialPageRoute(builder: (context) =>
                      //         UserStart()), (route) => false);
                      PhoneAuthCredential phoneCredential =
                          PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: code,
                      );
                      signInWithPhoneCredential(
                          phoneCredential, widget.choice, widget.phone);
                    },
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 30.h),
                        alignment: Alignment.center,
                        height: 45.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Verify",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void signInWithPhoneCredential(
      PhoneAuthCredential phoneCredential, String choice, String phone) async {
    try {
      final authCredential =
          await FirebaseAuth.instance.signInWithCredential(phoneCredential);
      if (authCredential.user != null && choice == "user") {
        print(phone);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var r = await Requests.post('http://64.227.160.250/api/register',
            body: {
              'password': '123456',
              'mobile': phone,
              'name': '',
              'type': 'user'
            },
            bodyEncoding: RequestBodyEncoding.FormURLEncoded);
        r.raiseForStatus();
        dynamic json = r.json();
        print(json);
        if (json.containsKey('_id')) {
          await prefs.setString('loggedIn', 'true');
          await prefs.setString('userID', json!['_id']);
          await prefs.setString('mobile', json!['mobile']);
          await prefs.setString('name', json!['name']);
          await prefs.setString('type', json!['type']);
          await FirebaseMessaging.instance.subscribeToTopic(json!['mobile']);
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return HomeScreen();
          // }));
          if(json!['type']=='user'){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }));
          }else if(json!['type']=='agent'){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AgentStartScreen();
            }));
          }else if(json!['type']=='client'){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ClientStartScreen();
            }));
          }else if(json!['type']=='delivery'){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DeliveryStartScreen();
            }));
          }
        }
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.tealAccent,
        duration: Duration(seconds: 2),
        content: Text("Enter Correct OTP"),
      ));
    }
  }
}
