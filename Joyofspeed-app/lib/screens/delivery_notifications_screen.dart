import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryNotificationsScreen extends StatefulWidget {
  const DeliveryNotificationsScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryNotificationsScreen> createState() => _DeliveryNotificationsScreenState();
}

class _DeliveryNotificationsScreenState extends State<DeliveryNotificationsScreen> {

  List allPickup = [];
  int completed=0, pending=0, cancelled=0;

  void getQueries() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = await prefs.getString('userID')??'';
    try {
      print(userID);
      var order = await Requests.get('http://64.227.160.250/api/parcel-delivery/${userID}',
          body: {
            'user': userID,
          },
          bodyEncoding: RequestBodyEncoding.FormURLEncoded);
      order.raiseForStatus();
      dynamic orderID = order.json();
      List tempPickup = [];
      for (int i = 0; i < orderID.length; i++) {
        tempPickup.add(orderID[i]);
      }
      allPickup = tempPickup;
      setState(() {});
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getQueries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff6ab36).withOpacity(0.8),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 60.h,left:30.w),
            child: Text(
              "Notificatons",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.w,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: allPickup.map((item) {
                  return Notifications(order:item['orderShownID'].toString());
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Divider(color: Colors.black45,),
  // ,

  Widget Notifications({required String order}){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
      margin: EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius:BorderRadius.only(topRight: Radius.circular(20),
        topLeft: Radius.circular(20)),
        color: Colors.brown.shade100,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.list_alt,size: 30.w,),
          SizedBox(width: 5.w,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order #"+order+":",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 19.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Expanded(
                    //   child: Padding(
                    //     padding: EdgeInsets.only(left: 100.w),
                    //     child: Text(
                    //       "5 minutes ago",
                    //       textAlign: TextAlign.end,
                    //       style: TextStyle(
                    //         color: Colors.grey,
                    //         fontSize: 12.w,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Container(
                  width: 300.w,
                  padding: EdgeInsets.only(top: 5.h),
                  child: Text(
                    "New Order #"+order +" has been assigneed to you.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.w,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
