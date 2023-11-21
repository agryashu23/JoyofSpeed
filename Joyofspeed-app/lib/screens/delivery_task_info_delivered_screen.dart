import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_of_speed/screens/delivery_sign_screen.dart';
import 'package:requests/requests.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'delivery_start_screen.dart';

class TaskInfoDelivery extends StatefulWidget {
  const TaskInfoDelivery({Key? key, required this.item}) : super(key: key);
  final dynamic item;

  @override
  State<TaskInfoDelivery> createState() => _TaskInfoDeliveryState();
}

class _TaskInfoDeliveryState extends State<TaskInfoDelivery> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6ab36),
      appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.white,
          title: Text("Order Detail"),
          centerTitle: true,
          backgroundColor: Color(0xfff6ab36)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25.w, top: 20.h),
            child: Text(
              "Order Summary",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16.w,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            height: 400.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '00000000${widget.item['orderShownID']}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.w,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${widget.item['orderTime'].toString().split(' GMT')[0]}',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.w,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.list_alt),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "Order Type:",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.w),
                  child: Text(
                    widget.item['name'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.account_circle),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "Customer Name",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.w),
                  child: Text(
                    widget.item['recipientName'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.phone),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "Contact No.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.w,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30.w),
                          child: InkWell(
                            onTap: (){

                            },
                            child: Text(
                              widget.item['recipientNumber'],
                              style: TextStyle(
                                decorationStyle: TextDecorationStyle.solid,
                                decoration: TextDecoration.underline,
                                fontSize: 15.w,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.w),
                      height: 40.h,
                      width: 40.w,
                      child: Image.asset('assets/images/caller.png'),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.home),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "Parcel Weight",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.w),
                  child: Text(
                    widget.item['weight'].toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.home),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "Address",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    try {
                      String googleUrl =
                          'https://www.google.com/maps/dir/?api=1&destination=28.7041,77.1025';
                      await launchUrl(Uri.parse(googleUrl));
                    } catch (e) {}
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 30.w),
                    child: Text(
                      widget.item['recipientAddress'],
                      style: TextStyle(
                        color: Colors.blue,
                        decorationStyle: TextDecorationStyle.solid,
                        decoration: TextDecoration.underline,
                        fontSize: 15.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.payment),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "Payment",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.w),
                  child: Text(
                    "Paid",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliverySignScreen(item: widget.item,)));
            },
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 100.h),
                alignment: Alignment.center,
                height: 40.h,
                width: 300.w,
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Mark as Delivered",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.w,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
