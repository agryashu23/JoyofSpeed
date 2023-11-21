// import 'package:flutter/material.dart';
// import 'package:joy_of_speed/screens/home_screen.dart';
// import 'package:requests/requests.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController _mobileController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   bool _isMobileValid = false;
//
//   @override
//   void dispose() {
//     _mobileController.dispose();
//     super.dispose();
//   }
//
//   void login(email, mobile) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     var r = await Requests.post('http://64.227.160.250/api/register',
//         body: {
//           'password': '123456',
//           'mobile': mobile,
//           'email': email,
//           'name': '',
//           'type': 'user'
//         },
//         bodyEncoding: RequestBodyEncoding.FormURLEncoded);
//     r.raiseForStatus();
//     dynamic json = r.json();
//     if (json.containsKey('_id')) {
//       await prefs.setString('loggedIn', 'true');
//       await prefs.setString('userID', json!['_id']);
//       await prefs.setString('mobile', json!['mobile']);
//       await prefs.setString('name', json!['name']);
//       Navigator.push(context, MaterialPageRoute(builder: (context){
//         return HomeScreen();
//       }));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.orange,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Card(
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   child: Padding(
//                     padding: EdgeInsets.all(24.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         TextField(
//                           controller: _mobileController,
//                           keyboardType: TextInputType.phone,
//                           decoration: InputDecoration(
//                             labelText: 'Mobile Number',
//                             errorText: _isMobileValid
//                                 ? null
//                                 : 'Please enter a valid mobile number',
//                           ),
//                           onChanged: (value) {
//                             setState(() {
//                               _isMobileValid =
//                                   RegExp(r'^[6-9]\d{9}$').hasMatch(value);
//                             });
//                           },
//                         ),
//                         SizedBox(height: 24.0),
//                         ElevatedButton(
//                           onPressed: _isMobileValid
//                               ? () {
//                                   login(_emailController.text,
//                                       _mobileController.text);
//                                 }
//                               : null,
//                           child: Text('Verify OTP'),
//                         ),
//                         SizedBox(height: 10.0),
//                         Center(
//                             child: Text(
//                           'OR',
//                           style: TextStyle(fontSize: 20),
//                         )),
//                         SizedBox(height: 10.0),
//                         ElevatedButton.icon(
//                           onPressed: () {
//                             // TODO: Login with Google logic
//                           },
//                           icon: Icon(Icons.home),
//                           label: Text('Login with Google'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//                 child: Container(
//                     padding: EdgeInsets.all(10),
//                     width: MediaQuery.of(context).size.width,
//                     alignment: Alignment.center,
//                     child: Text(
//                       'Terms and Conditions',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     )),
//                 bottom: 0)
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:joy_of_speed/screens/agent_home_screen.dart';
import 'package:joy_of_speed/screens/home_screen.dart';
import 'package:joy_of_speed/screens/login_otp_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? verifiId;
  TextEditingController phoneNo = new TextEditingController();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  bool agent = false;
  bool delivery = false;


  Future googleSign() async{
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null) return;
    _user = googleUser;
    final  googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
    if(result.user!=null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var r = await Requests.post('http://64.227.160.250/api/register',
          body: {
            'password': '123456',
            'mobile': '',
            'email': FirebaseAuth.instance.currentUser!.email,
            'name': '',
            'type': 'user'
          },
          bodyEncoding: RequestBodyEncoding.FormURLEncoded);
      r.raiseForStatus();
      dynamic json = r.json();
      if (json.containsKey('_id')) {
        await prefs.setString('loggedIn', 'true');
        await prefs.setString('userID', json!['_id']);
        await prefs.setString('mobile', json!['mobile']);
        await prefs.setString('name', json!['name']);
        await prefs.setString('type', json!['type']);
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return HomeScreen();
        // }));
        if(json!['type']=='user'){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        }else if(json!['type']=='agent'){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AgentHomeScreen();
          }));
        }
      }
      else {
        Fluttertoast.showToast(msg: "Error signing with google");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
      // StreamBuilder(
      // stream: FirebaseAuth.instance.authStateChanges(),
      // builder: (BuildContext context, AsyncSnapshot<User?> snapshot)
      // {
      // if (snapshot.connectionState == ConnectionState.waiting) {
      //   // joy.loader(false);
      // }
      // else if (snapshot.hasData) {
      //   return UserStart();
      //
      // }
      // else if (snapshot.hasError) {
      //   joy.loader(false);
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(
      //       SnackBar(
      //           content: Text(
      //               '')));
      // }
      // return
      Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.h),
            height: 200.h,
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
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40)),
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
                    height: 20.h,
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      "Welcome to Joy Of Speed",
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: Colors.brown,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      "Sign in to send couriers",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 25.h, left: 10.w, right: 10.w),
                    child: TextFormField(
                      controller: phoneNo,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter Your Mobile Number",
                        prefixText: "+91  ",
                        prefixStyle: TextStyle(fontSize: 15.w),
                        fillColor: Colors.grey.shade200,
                        contentPadding:
                        const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color(0xff8d8d8d),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIconColor: Color(0xff4f4f4f),
                        filled: true,
                      ),
                      validator: (value) {
                        if (phoneNo.text.length == 10) {
                          return null;
                        }
                        return "Enter Valid PhoneNumber";
                      },
                      onChanged: (value){
                        if(value.length == 10){
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () async{
                      if (phoneNo.text.length == 10) {
                        await FirebaseAuth.instance.signOut();
                        final QuerySnapshot result = await FirebaseFirestore.instance
                            .collection('agents')
                            .where('phone', isEqualTo: phoneNo.text.toString())
                            .limit(1).get();
                        final List<DocumentSnapshot> documents = result.docs;
                        if(documents.length==1){
                          agent=true;
                        }
                        final QuerySnapshot result2 = await FirebaseFirestore.instance
                            .collection('field-employee')
                            .where('phone', isEqualTo: phoneNo.text.toString())
                            .limit(1).get();
                        final List<DocumentSnapshot> documents2 = result2.docs;
                        if(documents2.length==1){
                          delivery=true;
                        }
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber:'+91${phoneNo.text.trimRight()}',
                          verificationCompleted:
                              (PhoneAuthCredential credential) {
                          },
                          verificationFailed:
                              (FirebaseAuthException e) {
                            print(e);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Enter Correct Mobile Number')));
                          },
                          codeSent: (String verificationId,
                              int? resendToken) {
                            verifiId = verificationId;
                            print(verifiId);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>LoginOTPScreen(choice:agent?"agent":delivery?"delivery":"user",verificationId:verifiId.toString(),phone:phoneNo.text)
                              ),
                            );
                          },
                          codeAutoRetrievalTimeout:
                              (String verId) {
                                verifiId = verId;

                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Please Enter Correct Mobile Number')));
                      }
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>UserOtp(choice:agent?"agent":delivery?"delivery":"user",verificationId:verifiId.toString(),phone:phoneNo.text)
                      //     ));

                    },
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 15.h),
                        alignment: Alignment.center,
                        height: 45.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Send Otp",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0),
                        child: Text(
                          'OR',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  Center(
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey
                            .shade200),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        // setState(() {
                        //   joy.loader(true);
                        //
                        // });
                        googleSign();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h,
                            horizontal: 15.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage(
                                  "assets/images/google_logo.png"),
                              height: 35.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Text(
                                'Sign in with Google',
                                style: TextStyle(
                                  fontSize: 17.w,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h,),
                  // Center(
                  //   child: OutlinedButton(
                  //     style: ButtonStyle(
                  //       backgroundColor: MaterialStateProperty.all(Colors.grey
                  //           .shade200),
                  //       shape: MaterialStateProperty.all(
                  //         RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(40),
                  //         ),
                  //       ),
                  //     ),
                  //     onPressed: () async {},
                  //     child: Padding(
                  //       padding: EdgeInsets.symmetric(vertical: 6.h),
                  //       child: Row(
                  //         mainAxisSize: MainAxisSize.min,
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: <Widget>[
                  //           Image(
                  //             image: AssetImage(
                  //                 "assets/images/facebook_logo.png"),
                  //             height: 35.0,
                  //           ),
                  //           Padding(
                  //             padding: EdgeInsets.only(left: 10.w),
                  //             child: Text(
                  //               'Sign in with Facebook',
                  //               style: TextStyle(
                  //                 fontSize: 17.w,
                  //                 color: Colors.black54,
                  //                 fontWeight: FontWeight.w600,
                  //               ),
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),


                ],
              ),
            ),
          ),
        ],
      ),
      // }
      // ),
    );
  }
}
