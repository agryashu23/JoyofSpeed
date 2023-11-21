import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joy_of_speed/screens/delivery_all_tasks.dart';
import 'package:joy_of_speed/screens/delivery_recent_tasks.dart';
import 'package:joy_of_speed/screens/delivery_settings_screen.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryHomeScreen extends StatefulWidget {
  const DeliveryHomeScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  TextEditingController searchController = new TextEditingController();
  List allPickup = [];
  List allOrders = [];
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
      completed =0;
      pending =0;
      cancelled=0;
      allOrders.clear();
      allOrders.addAll(orderID);
      for (int i = 0; i < orderID.length; i++) {
        if (orderID[i]['status'] == 'pending'||orderID[i]['status'] == 'pickup' || orderID[i]['status'] == 'out'||orderID[i]['status'] == 'pickup') {
          pending++;
        }else if (orderID[i]['status'] == 'delivered') {
          completed++;
        }else {
          cancelled++;
        }
      }
      List tempPickup = [];
      for (int i = 0; i < (orderID.length>2?3:orderID.length); i++) {
        if (orderID[i]['status'] != 'delivered' && orderID[i]['status'] != 'shipped') {
          tempPickup.add(orderID[i]);
        }
      }
      allPickup = tempPickup;
      setState(() {});
    }catch(e){
      print('');
    }
  }

  @override
  void initState() {
    super.initState();
    getQueries();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff6ab36).withOpacity(0.8),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50.h, left: 30.w),
                      child: Text(
                        "Hi",
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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => DeliverySettingScreen()));
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 70.h, right: 20.w),
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 25.w,
                      )),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20.h, left: 25.w, right: 25.w),
              child: TextFormField(
                controller: searchController,
                onChanged: (value){
                  var tempList = [];
                  if(value.isNotEmpty){
                    for(int i=0;i<allOrders.length;i++){
                      if(allOrders[i]['orderShownID'].toString().contains(value)||allOrders[i]['senderName'].toString().contains(value)){
                        tempList.add(allOrders[i]);
                      }
                    }
                  }else{
                    for (int i = 0; i < (allOrders.length>2?3:allOrders.length); i++) {
                      tempList.add(allOrders[i]);
                    }
                  }
                  allPickup = tempList;
                  setState(() {
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: Colors.white24,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  hintText: "Search Order",
                  hintStyle: TextStyle(fontSize: 18.w, color: Colors.white),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 24.w,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIconColor: Color(0xff4f4f4f),
                  filled: true,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.h),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20.h, left: 25.w),
                    child: Text(
                      "Task: ",
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 19.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>DeliveryAllTasks()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10.h),
                            width: 100.w,
                            height: 90.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Color(0xfff6ab36),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fire_truck,
                                  color: Colors.white,
                                  size: 30.w,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 1.h),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$completed',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.w,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 4.h,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Completed",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.w,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 10.h),
                            width: 100.w,
                            height: 90.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Color(0xfff6ab36),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.pending,
                                  color: Colors.white,
                                  size: 30.w,
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 1.h),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$pending',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.w,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(
                                      top: 4.h,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Pending",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.w,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ],
                            )),
                      ),
                      // Center(
                      //   child: Container(
                      //       margin: EdgeInsets.only(top: 10.h),
                      //       width: 100.w,
                      //       height: 90.h,
                      //       alignment: Alignment.center,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(25.0),
                      //         color: Color(0xfff6ab36),
                      //       ),
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Icon(
                      //             Icons.cancel,
                      //             color: Colors.white,
                      //             size: 30.w,
                      //           ),
                      //           Container(
                      //               margin: EdgeInsets.only(top: 1.h),
                      //               alignment: Alignment.center,
                      //               child: Text(
                      //                 '$cancelled',
                      //                 style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontSize: 18.w,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               )),
                      //           Container(
                      //               margin: EdgeInsets.only(
                      //                 top: 4.h,
                      //               ),
                      //               alignment: Alignment.center,
                      //               child: Text(
                      //                 "Cancelled",
                      //                 style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontSize: 12.w,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               )),
                      //         ],
                      //       )),
                      // ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20.h, left: 25.w),
                        child: Text(
                          "Recent Task:",
                          style: TextStyle(
                            color: Colors.brown,
                            fontSize: 19.w,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.h, right: 20.w),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>DeliveryAllTasks()));
                          },
                          child: Text(
                            "Show All",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.w,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  children: allPickup.map((item) {
                    return RecentTasks(
                        item:item,onTap:() async{
                          if(item['status']=='pickup'){
                            var order = await Requests.put('http://64.227.160.250/api/pickup-accepted/${item['_id']}',
                                body: {
                                  'user': '',
                                },
                                bodyEncoding: RequestBodyEncoding.FormURLEncoded);
                            order.raiseForStatus();
                            dynamic orderID = order.json();
                            getQueries();
                          }else if(item['status']=='out'){
                            var order = await Requests.put('http://64.227.160.250/api/delivery-accepted/${item['_id']}',
                                body: {
                                  'user': '',
                                },
                                bodyEncoding: RequestBodyEncoding.FormURLEncoded);
                            order.raiseForStatus();
                            dynamic orderID = order.json();
                            getQueries();
                          }
                          else{
                            await AwesomeDialog(
                              context: context,
                              autoHide: Duration(seconds: 1, milliseconds: 2000),
                              dialogType: DialogType.error,
                              titleTextStyle:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                              descTextStyle:
                              TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                              animType: AnimType.bottomSlide,
                              title: 'Wrong Operation',
                            ).show();
                          }
                    });
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
