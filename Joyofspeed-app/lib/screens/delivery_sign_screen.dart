import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:joy_of_speed/screens/delivery_start_screen.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:requests/requests.dart';

class DeliverySignScreen extends StatefulWidget {
  final dynamic item;

  const DeliverySignScreen({Key? key,required this.item}) : super(key: key);

  @override
  State<DeliverySignScreen> createState() => _DeliverySignScreenState();
}

class _DeliverySignScreenState extends State<DeliverySignScreen> {

  ByteData _img = ByteData(0);
  var color = Colors.indigo;
  var strokeWidth = 2.0;
  final _sign = GlobalKey<SignatureState>();
  final _sign2 = GlobalKey<SignatureState>();
  String currentDate = DateFormat('yyyy-MM-dd').add_jm().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6ab36),
      appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.white,
          title: Text("Order Deliver"),
          centerTitle: true,
          backgroundColor: Color(0xfff6ab36)
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
        Container(
        margin: EdgeInsets.only(left: 15.w, top: 10.h),
        child: Text(
          "Delivery date and time",
          style: TextStyle(
              color: Colors.black,
              fontSize: 16.w,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2),
        ),
      ),
            Container(
              margin: EdgeInsets.only(top: 8.h),
              padding: EdgeInsets.only(left: 15.w),
              width: 320.w,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100
              ),
              alignment: Alignment.centerLeft,
              child: Text(currentDate,style: TextStyle(fontSize: 16.w,fontWeight: FontWeight.w500),),
            ),
            Container(
              margin: EdgeInsets.only(left: 15.w, top: 15.h),
              child: Text(
                "Delivery Sign-",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.w,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2),
              ),
            ),

            Container(
              height: 140.h,
              margin: EdgeInsets.only( top: 8.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Signature(
                  color: color,
                  key: _sign,
                  onSign: () {
                    final sign = _sign.currentState;
                    // debugPrint(
                    //     '${sign?.points.length} points in the signature');
                  },
                  strokeWidth: strokeWidth,
                ),
              ),
            ),


            Container(
              margin: EdgeInsets.only(left: 15.w, top: 15.h),
              child: Text(
                "User's Sign-",
                style: TextStyle(
                    color: Color(0xfff6ab36),
                    fontSize: 18.w,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2),
              ),
            ),
            Container(
              height: 150.h,
              margin: EdgeInsets.only( top: 8.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Signature(
                  color: color,
                  key: _sign2,
                  onSign: () {
                    final sign = _sign2.currentState;
                    // debugPrint(
                    //     '${sign?.points.length} points in the signature');
                  },
                  strokeWidth: strokeWidth,
                ),
              ),
            ),
            // _img.buffer.lengthInBytes == 0 ? Container() : LimitedBox(
            //     maxHeight: 200.0,
            //     child: Image.memory(_img.buffer.asUint8List())),
            Align(
              alignment: Alignment.centerRight,
              child: MaterialButton(
                  color: Colors.white,
                  padding: EdgeInsets.all(0),
                  elevation: 0,
                  onPressed: () {
                    final sign = _sign2.currentState;
                    sign?.clear();
                    setState(() {
                      _img = ByteData(0);
                    });
                    // debugPrint("cleared");
                  },
                  child: Text("Clear",style: TextStyle(decoration:
                  TextDecoration.underline,fontSize: 16.w,color: Colors.indigoAccent),)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (){
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
                      descTextStyle:TextStyle(fontWeight: FontWeight.w400,fontSize: 15),
                      animType: AnimType.bottomSlide,
                      title: 'Cancel Delivery',
                      btnCancelText: "No",
                      btnOkText: "Yes",
                      desc: 'Do you really want to cancel delivery?',
                      btnCancelOnPress: () {
                        // Navigator.of(context).pop();
                      },
                      btnOkOnPress: () async{
                        // FirebaseAuth.instance.signOut();
                        // await controller.signOut();
                        // kIsWeb?Get.offAll(AdminLoginView()):Get.offAll(LoginView());
                      },
                    ).show();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top:15.h),
                    alignment: Alignment.center,
                    height: 40.h,
                    width: 140.w,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Cancel Order",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: ()async{
                    if(!_sign2.currentState!.hasPoints || !_sign.currentState!.hasPoints){
                      Fluttertoast.showToast(
                              msg: "Please Take Signature",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );

                    }
                    else{
                      final sign = _sign2.currentState;
                      //retrieve image data, do whatever you want with it (send to server, save locally...)
                      final image = await sign?.getData();
                      var data = await image?.toByteData(format: ui
                          .ImageByteFormat.png);
                      final encoded = base64.encode(data?.buffer
                          .asUint8List() as List<int>);
                      setState(() {
                        _img = data!;
                      });
                      var order = await Requests.put(
                          'http://64.227.160.250/api/parcel-delivered/${widget.item['_id']}',
                          body: {
                            'user': '',
                          },
                          bodyEncoding: RequestBodyEncoding.FormURLEncoded);
                      order.raiseForStatus();
                      dynamic orderID = order.json();
                      // await AwesomeDialog(
                      //   context: context,
                      //   autoHide: Duration(seconds: 1, milliseconds: 500),
                      //   dialogType: DialogType.success,
                      //   titleTextStyle:
                      //       TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      //   descTextStyle:
                      //       TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                      //   animType: AnimType.bottomSlide,
                      //   title: 'Pickup Completed',
                      // ).show();
                      await AwesomeDialog(
                        context: context,
                        autoHide: Duration(seconds: 1,milliseconds: 500),
                        dialogType: DialogType.success,
                        titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
                        descTextStyle:TextStyle(fontWeight: FontWeight.w400,fontSize: 15),
                        animType: AnimType.bottomSlide,
                        title: 'Delivery Confirmed',
                      ).show();
                    sign?.clear();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (context)=>DeliveryStartScreen()), (route) => false);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top:10.h),
                    alignment: Alignment.center,
                    height: 40.h,
                    width: 150.w,
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Confirm Delivery",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
