import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:joy_of_speed/screens/edit_profile_screen.dart';
import 'package:joy_of_speed/screens/login_screen.dart';
import 'package:joy_of_speed/screens/privacy_policy_screen.dart';
import 'package:joy_of_speed/screens/raise_query_screen.dart';
import 'package:joy_of_speed/screens/your_couriers_screen.dart';
import 'package:joy_of_speed/screens/your_queries_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {

  String userName ='';
  String userMobile ='';
  File? _image;

  @override
  void initState() {
    super.initState();
    handleData();
    _loadImage();
  }

  void _loadImage() async {
    final appDir = await getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/my_image.jpg');
    if (file.existsSync()) {
      setState(() {
        _image = file;
      });
    }
  }

  void handleData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = await prefs.getString('mobile')??'';
    String? name = await prefs.getString('name')??'';
    setState(() {
      userName = name;
      userMobile = mobile;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50.h),
              child: Container(
                  child: Text("Profile", style: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.w,
                      fontFamily: 'Raleway'),)),
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Container(
                    child: _image == null
                        ? CircleAvatar(
                      minRadius: 60.w,
                      maxRadius: 60.w,
                      backgroundImage:
                      AssetImage('assets/images/user2.png'),
                    )
                        : CircleAvatar(
                      minRadius: 60.w,
                      maxRadius: 60.w,
                      backgroundImage: FileImage(_image!),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('$userName',
                    // controller.userData[0].userName!,
                    style: TextStyle(
                        fontSize: 18.w,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('$userMobile',
                    // controller.userData[0].userEmail!,
                    // style: GoogleFonts.robotoCondensed(
                    //   fontSize: 16,
                    // ),
                  ),
                  GestureDetector(
                    onTap: () async {
                     await Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => EditProfileScreen()));
                     handleData();
                     _loadImage();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15.h),
                      alignment: Alignment.center,
                      height: 40.h,
                      width: 140.w,
                      decoration: BoxDecoration(
                        color: Color(0xfff6ab36).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Edit Profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.w,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      thickness: 0.6,
                      color: Color(0xFFD6D6D6),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  InkWell(
                    onTap: () {
                      // Get.to(Settings2());
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => YourCouriersScreen()));
                    },
                    child: profileMenuItem(
                        itemName: 'Your Couriers',
                        itemIcon: Icons.local_shipping_outlined),
                  ),
                  // SizedBox(height: 20.h),
                  // InkWell(
                  //   onTap: () {
                  //
                  //   },
                  //   child: profileMenuItem(
                  //       itemName: 'Pricing Details',
                  //       itemIcon: Icons.price_change_outlined),
                  // ),
                  SizedBox(height: 20.h),
                  InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(builder: (context) => RaiseQueryScreen()));
                    },
                    child: profileMenuItem(
                        itemName: 'Raise a Query',
                        itemIcon: Icons.query_builder),
                  ),
                  SizedBox(height: 20.h),
                  InkWell(
                    onTap: () async {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => YourQueriesScreen()));
                      // await launchUrl(Uri.parse(
                      //     "whatsapp://send?phone=+917983448199&text=Hey!"));

                    },
                    child: profileMenuItem(
                        itemName: 'Your Queries',
                        itemIcon: Icons.warning_amber),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      thickness: 0.6,
                      color: Color(0xFFD6D6D6),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
                    },
                    child: profileMenuItem(
                        itemName: 'Privacy Policy',
                        itemIcon: Icons.task_outlined),
                  ),
                  SizedBox(height: 20.h),
                  InkWell(
                      onTap: () {
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
                            await prefs.setString('email', '');
                            await prefs.setString('type', '');
                            final appDir = await getApplicationDocumentsDirectory();
                            final file = File('${appDir.path}/my_image.jpg').delete(recursive: true);
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                        ).show();
                      },
                      child: profileMenuItem(
                          itemName: 'Log Out', itemIcon: Icons.logout)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container profileMenuItem(
      {required String itemName, required IconData itemIcon}) {
    return Container(
      padding: EdgeInsets.only(left: 30.w,right: 40.w),
      height: 40,
      child: Row(
        children: [
          Container(
            height: 40.w,
            width: 40.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400]!,
                  offset: const Offset(
                    0.0,
                    0.5,
                  ),
                  blurRadius: 5.0,
                  spreadRadius: 0.2,
                ), //BoxShadow
                BoxShadow(
                  color: Colors.white,
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ), //BoxShadow
              ],
            ),
            child: Icon(
              itemIcon,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            itemName,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Color(0xFF7D7F88),
            size: 18,
          ),
        ],
      ),
    );
  }
}

