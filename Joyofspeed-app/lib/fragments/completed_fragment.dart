import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joy_of_speed/components/file_handle_api.dart';
import 'package:joy_of_speed/components/pdf_invoive_api.dart';
import 'package:joy_of_speed/screens/courier_history_screen.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CompletedFragment extends StatefulWidget {
  const CompletedFragment({Key? key}) : super(key: key);

  @override
  State<CompletedFragment> createState() => _CompletedFragmentState();
}

class _CompletedFragmentState extends State<CompletedFragment> {

  List<dynamic> items = [];

  void getQueries() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = await prefs.getString('userID')??'';
    try {
      var order = await Requests.get(
          'http://64.227.160.250/api/parcel/${userID}',
          body: {
            'user': userID,
          },
          bodyEncoding: RequestBodyEncoding.FormURLEncoded);
      order.raiseForStatus();
      dynamic orderID = order.json();
      List _queries = [];
      for (int i = 0; i < orderID.length; i++) {
        if (orderID[i]['status'] == 'delivered') {
          _queries.add(orderID[i]);
        }
      }
      setState(() {
        items.addAll(_queries);
      });
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
    return Container(
      margin: EdgeInsets.fromLTRB(2, 5, 2, 5),
      child: ListView(
        children: items.map((item) {
          return InkWell(
            onTap: ()async{
              File file = await PdfInvoiceApi.generate([
                item['senderName'],
                item['senderNumber'],
                '${item['senderAddress']}, ${item['senderCity']}, ${item['senderState']}, ${item['senderZip']}'
              ],[
                [
                  'Tracking No. #00000000${item['orderShownID']}',
                  '0 %',
                  'Rs. 200',
                ]
              ], item['amount'],'0');
                await launchUrl(Uri.parse(file.path));
            },
            child: Container(
              width:320.w ,
              height: 160.w,
              child: Card(
                color: Colors.orangeAccent.shade100,
                margin: EdgeInsets.fromLTRB(2, 5, 2, 5),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.w),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment:MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20.w,top: 15.h),
                              child: Text("Tracking Number",style: TextStyle(color: Colors.black45,fontSize: 16.w,),),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.w,top: 5.h),
                              child: Text('00000000${item['orderShownID']}',style: TextStyle(color: Colors.black,fontSize: 18.w,fontWeight: FontWeight.bold),),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 25.h,
                          width: 80.w,
                          margin: EdgeInsets.only(top: 22.h,right: 20.w),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {

                              File file = await PdfInvoiceApi.generate([
                                item['senderName'],
                                item['senderNumber'],
                                '${item['senderAddress']}, ${item['senderCity']}, ${item['senderState']}, ${item['senderZip']}'
                              ],[
                                [
                                  'Tracking No. #00000000${item['orderShownID']}',
                                  '0 %',
                                  'Rs. 200',
                                ]
                              ], item['amount'],'0');
                              await launchUrl(Uri.parse(file.path));
                            },
                            child: Text(
                              "Invoice",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.w),
                      child: Divider(color: Colors.black,),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 25.w,top: 1.h),
                              width:12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.w),
                                  border: Border.all(color:Colors.red,width: 2)
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Text(item['senderCity'],style: TextStyle(color: Colors.black,fontSize: 16.w,fontWeight: FontWeight.w500),),
                            ),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.only(right: 25.w),
                          child: Text("N/A",style: TextStyle(color: Colors.black45,fontSize: 16.w,),),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20.w),
                                width:12.w,
                                height: 20.w,
                                child: Icon(Icons.location_on_outlined),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15.w),
                                child: Text(item['recipientCity'],style: TextStyle(color: Colors.black,fontSize: 16.w,fontWeight: FontWeight.w500),),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right:25.w),
                            child: Text("N/A",style: TextStyle(color: Colors.black45,fontSize: 16.w,),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
