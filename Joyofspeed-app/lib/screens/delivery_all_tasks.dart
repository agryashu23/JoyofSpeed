import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joy_of_speed/screens/delivery_recent_tasks.dart';
import 'package:joy_of_speed/screens/delivery_settings_screen.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DeliveryAllTasks extends StatefulWidget {
  const DeliveryAllTasks({Key? key}) : super(key: key);

  @override
  State<DeliveryAllTasks> createState() => _DeliveryAllTasksState();
}

class _DeliveryAllTasksState extends State<DeliveryAllTasks> {

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
      appBar: AppBar(
        title: Text('All Tasks'),
        backgroundColor: Color(0xfff6ab36).withOpacity(0.8),
      ),
      body: Container(
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
    );
  }
}
