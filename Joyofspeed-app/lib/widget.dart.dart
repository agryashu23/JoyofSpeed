
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

TextStyle stylee = TextStyle(color: Colors.white,
    fontSize: 20.w,fontWeight: FontWeight.w300,letterSpacing: 1.5);
TextStyle stylee2 = TextStyle(color: Colors.black,
  fontSize: 20.w,fontWeight: FontWeight.w400,);


Widget labelText(String s) {
  return Container(
    margin: EdgeInsets.only(left: 25.w, top: 15.h),
    child: Text(
      s,
      style: TextStyle(
          color: Colors.black,
          fontSize: 15.w,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2),
    ),
  );
}

Widget forms({required TextEditingController controller, required String choice}) {
  return Container(
    margin: EdgeInsets.only(top: 4.h, left: 20.w, right: 20.w),
    child: TextFormField(
      controller: controller,
      keyboardType: choice=="Number"?TextInputType.number:TextInputType.text,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade200,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
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
      // validator: (value) {
      //   if (controller.text.length == 0) {
      //     return "Enter the details";
      //   }
      //   return null;
      // },
    ),
  );
}
Future<bool> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Fluttertoast.showToast(
      msg: "Location services are disabled. Please enable the services", timeInSecForIosWeb: 4);
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(
          msg: "Location permissions are denied", timeInSecForIosWeb: 4);
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    Fluttertoast.showToast(
        msg: "Location permissions are permanently denied, we cannot request permissions.", timeInSecForIosWeb: 4);
    return false;
  }
  return true;
}