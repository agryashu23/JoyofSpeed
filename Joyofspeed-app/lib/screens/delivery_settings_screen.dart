import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joy_of_speed/screens/widget.dart.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DeliverySettingScreen extends StatefulWidget {
  const DeliverySettingScreen({Key? key}) : super(key: key);

  @override
  State<DeliverySettingScreen> createState() => _DeliverySettingScreenState();
}

class _DeliverySettingScreenState extends State<DeliverySettingScreen> {

  String userName ='';
  String userMobile ='';
  String userAddress = '';

  @override
  void initState() {
    super.initState();
    handleData();
  }

  void handleData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = await prefs.getString('mobile')??'';
    String? name = await prefs.getString('name')??'';
    String? address = await prefs.getString('address')??'';
    setState(() {
      userName = name;
      userMobile = mobile;
      userAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6ab36),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 50.h),
              child: Text("Profile",style: TextStyle(color: Colors.white,
                  fontSize: 22.w,fontWeight: FontWeight.bold,letterSpacing: 1.5)),
            ),

          ),
          Container(
            margin: EdgeInsets.only(left: 20.w,top: 25.h),
            child: Text("Name:-",style: stylee,),
          ),
          Container(
            margin: EdgeInsets.only(left: 20.w,top: 8.h),
            child: Text
              ('$userName',style: stylee2,),
          ),
          Container(
            margin: EdgeInsets.only(left: 20.w,top: 25.h),
            child: Text("Mobile No.:-",style: stylee,),
          ),
          Container(
            margin: EdgeInsets.only(left: 20.w,top: 8.h),
            child: Text('$userMobile',style: stylee2,),
          ),
          Container(
            margin: EdgeInsets.only(left: 20.w,top: 25.h),
            child: Text("Address:-",style: stylee,),
          ),
          Container(
            margin: EdgeInsets.only(left: 20.w,top: 8.h),
            child: Text('$userAddress',style: stylee2,),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 40.h),
              child: Text("Contact Us:",style: TextStyle(color: Colors.white,
                  fontSize: 22.w,fontWeight: FontWeight.bold,letterSpacing: 1.5)),
            ),
          ),
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 60.h,
                width: 60.w,
                child: Image.asset('assets/images/whats_app.png'),
              ),
              Container(
                height: 60.h,
                width: 60.w,
                child: Image.asset('assets/images/caller-remove.png'),
              )
            ],
          )

        ],
      ),
    );
  }
}
