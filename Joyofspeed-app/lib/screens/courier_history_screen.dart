import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourierHistoryScreen extends StatefulWidget {
  final String data;
  const CourierHistoryScreen({Key? key,required this.data}) : super(key: key);

  @override
  State<CourierHistoryScreen> createState() => _CourierHistoryScreenState(data);
}

class _CourierHistoryScreenState extends State<CourierHistoryScreen> {

  final String? data;
  _CourierHistoryScreenState(this.data);
  dynamic orderData = {};

  List<StepperData> stepperData = [];
  void getQueries() async {
    try {
      var order = await Requests.get(
          'http://64.227.160.250/api/parcel-id/${data}',
          body: {
            'user': data,
          },
          bodyEncoding: RequestBodyEncoding.FormURLEncoded);
      order.raiseForStatus();
      setState(() {
        orderData = order.json();
        print(orderData);
        if(orderData['status']=='delivered')
          {
            stepperData = [
              StepperData(
                  title: StepperText(
                    "Order Placed",
                  ),
                  subtitle: StepperText('''Your order has been placed\n${orderData['orderTime']}'''),
                  iconWidget: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  )),
              // StepperData(
              //     title: StepperText("Dispatched"),
              //     subtitle: StepperText('''Your order has been dispatched\nTue,3 Mar 23 - 9:59pm'''),
              //     iconWidget: Container(
              //       padding: const EdgeInsets.all(8),
              //       decoration:  BoxDecoration(
              //           color: Colors.blue,
              //           // border: Border.all(color: Colors.grey,width: 2.0),
              //           borderRadius: BorderRadius.all(Radius.circular(30))),
              //     )),
              StepperData(
                  title: StepperText("Delivered",),
                  subtitle: StepperText(
                      orderData['status']=='delivered'?'Your order has been delivered':'Your order has not been delivered yet.'),
                  iconWidget: Container(
                    padding: const EdgeInsets.all(8),
                    decoration:  BoxDecoration(
                      // color: Colors.redAccent,
                        border: Border.all(color: Colors.grey,width: 2.0),

                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  )),
            ];
          }
        else{
          stepperData = [
            StepperData(
                title: StepperText(
                  "Order Placed",
                ),
                subtitle: StepperText('''Your order has been placed\n${orderData['orderTime']}'''),
                iconWidget: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                )),
            // StepperData(
            //     title: StepperText("Dispatched"),
            //     subtitle: StepperText('''Your order has been dispatched\nTue,3 Mar 23 - 9:59pm'''),
            //     iconWidget: Container(
            //       padding: const EdgeInsets.all(8),
            //       decoration:  BoxDecoration(
            //           color: Colors.blue,
            //           // border: Border.all(color: Colors.grey,width: 2.0),
            //           borderRadius: BorderRadius.all(Radius.circular(30))),
            //     )),
            StepperData(
                title: StepperText("Shipped"),
                subtitle: StepperText(
                    orderData['status']=='shipped'?'Your order has been shipped':'Your order has not been shipped yet.'),
                iconWidget: Container(
                  padding: const EdgeInsets.all(8),
                  decoration:  BoxDecoration(
                    // color: Colors.green,
                      border: Border.all(color: Colors.grey,width: 2.0),

                      borderRadius: BorderRadius.all(Radius.circular(30))),
                )),
            StepperData(
                title: StepperText("Delivered",),
                subtitle: StepperText(
                    orderData['status']=='delivered'?'Your order has been delivered':'Your order has not been delivered yet.'),
                iconWidget: Container(
                  padding: const EdgeInsets.all(8),
                  decoration:  BoxDecoration(
                    // color: Colors.redAccent,
                      border: Border.all(color: Colors.grey,width: 2.0),

                      borderRadius: BorderRadius.all(Radius.circular(30))),
                )),
          ];
        }
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                  color: Color(0xfff6ab36).withOpacity(0.8),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.arrow_back,color: Colors.white,size: 30.w,)),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20.w),
                    child: Text("Courier Details",style: TextStyle(color: Colors.white,fontSize: 20.w,fontWeight: FontWeight.bold),),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.h, left: 25.w),
              child: AnotherStepper(
                stepperList: stepperData,
                stepperDirection: Axis.vertical,
                iconWidth: 12.w,
                iconHeight: 12.w,
                activeBarColor: Colors.blue,
                inActiveBarColor: Colors.grey,
                verticalGap: 35.h,
                activeIndex: 1,
                barThickness: 4,
              ),
            ),

            Container(
              margin: EdgeInsets.only(left:20.w,top: 60.h),
              padding: EdgeInsets.only(top: 8.h,bottom: 10.h),
              width: 310.w,
              decoration: BoxDecoration(
                  color: Color(0xfff6ab36).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Shipment Details-",style: TextStyle(fontSize: 17.w,fontWeight: FontWeight.bold,),),
                  Padding(
                    padding:  EdgeInsets.only(top: 8.h),
                    child: Text("Waiting for Pickup!",style: TextStyle(fontSize: 14.w,fontWeight: FontWeight.w400,color: Colors.grey),),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: 8.h),
                    child: Text("Order Placed.",style: TextStyle(fontSize: 14.w,fontWeight: FontWeight.w400,color: Colors.grey),),
                  ),

                ],
              ),

            )
          ],
        ),
      ),
    );
  }
//
}
