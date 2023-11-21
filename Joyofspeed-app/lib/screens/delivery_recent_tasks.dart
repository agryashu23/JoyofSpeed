import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joy_of_speed/screens/delivery_task_info_delivered_screen.dart';
import 'package:joy_of_speed/screens/delivery_task_info_screen.dart';

class RecentTasks extends StatefulWidget {
  const RecentTasks({Key? key, required this.item, required this.onTap}) : super(key: key);

  final dynamic item;
final Future<void> Function() onTap;

  @override
  State<RecentTasks> createState() => _RecentTasksState();
}

class _RecentTasksState extends State<RecentTasks> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(widget.item['status'] != 'delivered') {
          widget.item['status'] == 'pickup_accepted' ? Navigator.of(
              context, rootNavigator: true).push(MaterialPageRoute(
              builder: (context) => TaskInfo(item: widget.item)))
              : widget.item['status'] == 'delivery_accepted' ? Navigator.of(
              context, rootNavigator: true).push(MaterialPageRoute(
              builder: (context) => TaskInfoDelivery(item: widget.item)))
              : widget.onTap();
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 5.h),
        width:320.w ,
        height: 180.w,
        child: Card(
          color: Colors.grey.shade300,
          margin: EdgeInsets.all(2),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.w,top: 15.h),
                          child: Text('00000000${widget.item['orderShownID']}',style: TextStyle(color: Colors.black,fontSize: 16.w,fontWeight: FontWeight.w500),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 24.w,top: 2.h),
                          child: Text("Ordered At: ${widget.item['orderTime'].toString().split(' GMT')[0]}",style: TextStyle(color: Colors.black54,fontSize: 11.w,),),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 30.h,
                    width: 75.w,
                    margin: EdgeInsets.only(top: 15.h,right: 20.w),
                    decoration: BoxDecoration(
                      color: widget.item['status']=="pickup"||widget.item['status']=="out"?Colors.brown.shade300:Color(0xfff6ab36),
                      borderRadius: BorderRadius.circular(25.w),boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],

                    ),
                    child: Text(
                      widget.item['status']=='pickup_accepted'?'Accepted':widget.item['status']=='pickedup'?'PickedUp':widget.item['status']=='out'?'Delivery':widget.item['status']=='delivery_accepted'?'Accepted':widget.item['status']=='delivered'?'Delivered':'Pickup',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.w,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.1
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.w,top: 10.h),
                child: Text("Customer Info:",style: TextStyle(color: Colors.black,fontSize: 14.w,fontWeight: FontWeight.w500),),
              ),
              Container(
                margin: EdgeInsets.only(top: 3.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 24.w),
                          child: Icon(Icons.account_circle,color: Colors.grey,size: 15.w,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 3.w),
                          child: Text(widget.item['senderName'],style: TextStyle(color: Colors.grey,fontSize: 14.w,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 24.w),
                          child: Icon(Icons.location_on,color: Colors.grey,size: 15.w,),
                        ),
                        Container(
                          width: 270.w,
                          padding: EdgeInsets.only(left: 3.w),
                          child: Text(widget.item['senderAddress'],style: TextStyle(color: Colors.grey,fontSize: 14.w,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 24.w),
                          child: Icon(Icons.location_searching,color: Colors.grey,size: 15.w,),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 3.h,left: 4.w),
                          child: Text("Pickup: Sender",style: TextStyle(color: Colors.black,fontSize: 14.w,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}
