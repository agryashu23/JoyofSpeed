import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joy_of_speed/screens/agent_send_parcel_screen.dart';
import 'package:joy_of_speed/screens/agent_wallet_screen.dart';
import 'package:joy_of_speed/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AgentHomeScreen extends StatefulWidget {
  const AgentHomeScreen({Key? key}) : super(key: key);

  @override
  State<AgentHomeScreen> createState() => _AgentHomeScreenState();
}

class _AgentHomeScreenState extends State<AgentHomeScreen> {
  String? name ='Agent';

  @override
  void initState() {
    super.initState();
    handleData();
  }

  void handleData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nameT = await prefs.getString('name')??'User';
    setState(() {
      name = nameT;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6ab36).withOpacity(0.8),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 70.h, left: 30.w),
                      child: Text(
                        "Hi, $name",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.w,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.h, left: 30.w),
                      child: Text(
                        "Welcome to JoyofSpeed",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.w,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 70.h,right: 10.w),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 70.h,
                    width: 70.w,
                  ),
                ),


              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 30.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)),
                  color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 25.h, left: 30.w),
                    child: Text(
                      "What are you looking for today?",
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 18.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 35.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        "assets/images/home_ad.jpg",

                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AgentSendParcelScreen()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10.h),
                            width: 90.w,
                            height: 80.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Color(0xfff6ab36).withOpacity(0.8),
                            ),
                            child: Image.asset(
                              "assets/images/sendOrder.png",
                              height: 50.h,
                              width: 50.w,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: (){
                            // print(FirebaseAuth.instance.currentUser!.uid);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AgentWalletScreen()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10.h),
                            width: 90.w,
                            height: 80.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Color(0xfff6ab36).withOpacity(0.8),
                            ),
                            child: Image.asset(
                              "assets/images/wallet-sys.png",
                              height: 90.h,
                              width: 90.w,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: ()async{
                            Uri phoneno = Uri.parse('tel:+916232446830');
                            await launchUrl(phoneno);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10.h),
                            width: 90.w,
                            height: 80.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Color(0xfff6ab36).withOpacity(0.8),
                            ),
                            child: Image.asset(
                              "assets/images/caller-remove.png",
                              height: 50.h,
                              width: 50.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 5.h,left: 10.w),
                            alignment: Alignment.center,
                            child: Text("Send Parcel", style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.w,
                              fontWeight: FontWeight.bold,
                            ),)
                        ),
                      ),
                      Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 5.h,left: 10.w),
                            alignment: Alignment.center,
                            child: Text("Your Wallet", style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.w,
                              fontWeight: FontWeight.bold,
                            ),)
                        ),
                      ),
                      Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 5.h,left: 20.w),
                            alignment: Alignment.center,
                            child: Text("Contact Us", style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.w,
                              fontWeight: FontWeight.bold,
                            ),)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h,),
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          titleTextStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                          descTextStyle: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                          animType: AnimType.bottomSlide,
                          title: 'Log Out',
                          desc: 'Are you really want to Log Out?',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () async {
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('loggedIn', 'false');
                            await prefs.setString('userID', '');
                            await prefs.setString('mobile', '');
                            await prefs.setString('name', '');
                            await prefs.setString('type', '');
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                        ).show();
                        },
                      child: Container(
                        color: Colors.redAccent,
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        child: Text("log out"),
                      ),
                    ),
                  )


                ],
              ),


            )
          ],
        ),
      ),
    );
  }
}
