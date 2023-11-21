import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourierHistoryTrackScreen extends StatefulWidget {
  final String value;
  const CourierHistoryTrackScreen({Key? key, required this.value}) : super(key: key);

  @override
  State<CourierHistoryTrackScreen> createState() => _CourierHistoryTrackScreenState(value);
}

class _CourierHistoryTrackScreenState extends State<CourierHistoryTrackScreen> {
  final String? value;

  _CourierHistoryTrackScreenState(this.value);

  dynamic orderData = {};
  

  List<StepperData> stepperData = [];
  void getQueries() async {
      var order = await Requests.get(
          'http://64.227.160.250/api/parcel-id-track/${value!.toUpperCase().replaceAll('0', '')}',
          body: {
            // 'user': data,
          },
          bodyEncoding: RequestBodyEncoding.FormURLEncoded);
      order.raiseForStatus();
      print(order.json());
      setState(() {
        orderData = order.json()[0];
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
  }

  @override
  void initState() {
    super.initState();
    getQueries();
  }


  List<StepperData> StepperStatus(status){
    if(status=='delivered'){
      return [
        StepperData(
            title: StepperText(
              "Order Placed",
            ),
            subtitle: StepperText('Your order has been placed\n${orderData['orderTime']}'),
            iconWidget: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(30),
                  ),
              ),
            ),
        ),
        StepperData(
            title: StepperText("Delivered",),
            subtitle: StepperText('Your order has been delivered'),
            iconWidget: Container(
              padding: const EdgeInsets.all(8),
              decoration:  BoxDecoration(
                // color: Colors.redAccent,
                  border: Border.all(color: Colors.grey,width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(30),
                  ),
              ),
            ),
        ),
      ];
    }else if(status=='shipped'){
      return [
        StepperData(
            title: StepperText(
              "Order Placed",
            ),
            subtitle: StepperText('Your order has been placed\n${orderData['orderTime']}'),
            iconWidget: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(30),
                  ),
              ),
            ),
        ),
        StepperData(
            title: StepperText(
              "Shipped",
            ),
            subtitle: StepperText('Your order has been shipped!'),
            iconWidget: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
            )),
        StepperData(
            title: StepperText("Delivered",),
            subtitle: StepperText('Your order has been delivered'),
            iconWidget: Container(
              padding: const EdgeInsets.all(8),
              decoration:  BoxDecoration(
                // color: Colors.redAccent,
                  border: Border.all(color: Colors.grey,width: 2.0),

                  borderRadius: BorderRadius.all(Radius.circular(30))),
            )),
      ];
    }else if(status=='out'||status=='delivery_accepted'){
      return [
        StepperData(
            title: StepperText(
              "Order Placed",
            ),
            subtitle: StepperText('Your order has been placed\n${orderData['orderTime']}'),
            iconWidget: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
            )),
        StepperData(
            title: StepperText(
              "Out for Delivery",
            ),
            subtitle: StepperText('Your order is out for delivery!'),
            iconWidget: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
            )),
        StepperData(
            title: StepperText("Delivered",),
            subtitle: StepperText('Your order has been delivered'),
            iconWidget: Container(
              padding: const EdgeInsets.all(8),
              decoration:  BoxDecoration(
                // color: Colors.redAccent,
                  border: Border.all(color: Colors.grey,width: 2.0),

                  borderRadius: BorderRadius.all(Radius.circular(30))),
            )),
      ];
    }else {
      return [
        StepperData(
            title: StepperText(
              "Order Placed",
            ),
            subtitle: StepperText('Your order has been placed\n${orderData['orderTime']}'),
            iconWidget: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
            )),
        StepperData(
            title: StepperText(
              "Pickup",
            ),
            subtitle: StepperText('Your order is waiting for pickup!'),
            iconWidget: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
            )),
        StepperData(
            title: StepperText("Delivered",),
            subtitle: StepperText('Your order has been delivered'),
            iconWidget: Container(
              padding: const EdgeInsets.all(8),
              decoration:  BoxDecoration(
                // color: Colors.redAccent,
                  border: Border.all(color: Colors.grey,width: 2.0),

                  borderRadius: BorderRadius.all(Radius.circular(30))),
            )),
      ];
    }
  }

  Widget OrderStatus(status){
    if(status=='delivered'){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Shipment Details-",style: TextStyle(fontSize: 17.w,fontWeight: FontWeight.bold,),),
          Padding(
            padding:  EdgeInsets.only(top: 8.h),
            child: Text("Your Item is Delivered!",style: TextStyle(fontSize: 14.w,fontWeight: FontWeight.w400,color: Colors.grey),),
          ),

        ],
      );
    }else if(status=='shipped'){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Shipment Details-",style: TextStyle(fontSize: 17.w,fontWeight: FontWeight.bold,),),
          Padding(
            padding:  EdgeInsets.only(top: 8.h),
            child: Text("Order is placed!",style: TextStyle(fontSize: 14.w,fontWeight: FontWeight.w400,color: Colors.grey),),
          ),
          Padding(
            padding:  EdgeInsets.only(top: 8.h),
            child: Text("Order has been pickedup!",style: TextStyle(fontSize: 14.w,fontWeight: FontWeight.w400,color: Colors.grey),),
          ),
          Padding(
            padding:  EdgeInsets.only(top: 8.h),
            child: Text("Order is shipped!",style: TextStyle(fontSize: 14.w,fontWeight: FontWeight.w400,color: Colors.grey),),
          ),
        ],
      );
    }else if(status=='out'||status=='delivery_accepted'){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Shipment Details-",style: TextStyle(fontSize: 17.w,fontWeight: FontWeight.bold,),),
          Padding(
            padding:  EdgeInsets.only(top: 8.h),
            child: Text("Order is placed!",style: TextStyle(fontSize: 14.w,fontWeight: FontWeight.w400,color: Colors.grey),),
          ),
          Padding(
            padding:  EdgeInsets.only(top: 8.h),
            child: Text("Order has been pickedup!",style: TextStyle(fontSize: 14.w,fontWeight: FontWeight.w400,color: Colors.grey),),
          ),
          Padding(
            padding:  EdgeInsets.only(top: 8.h),
            child: Text("Order is shipped!",style: TextStyle(fontSize: 14.w,fontWeight: FontWeight.w400,color: Colors.grey),),
          ),
          Padding(
            padding:  EdgeInsets.only(top: 8.h),
            child: Text("Order is out for delivery!",style: TextStyle(fontSize: 14.w,fontWeight: FontWeight.w400,color: Colors.grey),),
          ),
        ],
      );
    }else if(status=='pending'||status=='pickup'||status=='pickup_accepted'){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Shipment Details-",style: TextStyle(fontSize: 17.w,fontWeight: FontWeight.bold,),),
          Padding(
            padding:  EdgeInsets.only(top: 8.h),
            child: Text("Order is placed!",style: TextStyle(fontSize: 14.w,fontWeight: FontWeight.w400,color: Colors.grey),),
          ),
          Padding(
            padding:  EdgeInsets.only(top: 8.h),
            child: Text("Waiting for the order to be pickedup!",style: TextStyle(fontSize: 14.w,fontWeight: FontWeight.w400,color: Colors.grey),),
          ),
        ],
      );
    }
    else{
      return Text("Please Wait",style: TextStyle(fontSize: 17.w,fontWeight: FontWeight.bold,));
    }
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
                  ),
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
              child: OrderStatus(orderData['status']),

            )
          ],
        ),
      ),
    );
  }
//
}
