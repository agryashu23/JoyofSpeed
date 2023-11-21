import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joy_of_speed/screens/courier_history_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joy_of_speed/screens/courier_history_track_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackFragment extends StatefulWidget {
  const TrackFragment({Key? key}) : super(key: key);

  @override
  State<TrackFragment> createState() => _TrackFragmentState();
}

class _TrackFragmentState extends State<TrackFragment> {

  TextEditingController shipmentController = new TextEditingController();
  String? name ='Customer';

  @override
  void initState() {
    super.initState();
    handleData();
  }

  void handleData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? nameT = await prefs.getString('name')??'Customer';

    setState(() {
      name = nameT;
    });

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
          children: [
            Container(
              margin: EdgeInsets.only(top: 70.h, left: 30.w),
              child: Text(
                "Hi, $name",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.w,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.h, left: 30.w),
              child: Text(
                "Let's Track Your Courier-",
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 18.w,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 40.h),
                width: 360.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25)),
                    color: Colors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20.h, left: 30.w),
                      child: Text(
                        "Track Courier",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.w,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.h, left: 30.w),
                      child: Text(
                        "Please enter the tracking number of courier",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.w,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 40.h, left: 30.w, right: 30.w),
                      child: TextFormField(
                        controller: shipmentController,
                        autofocus: false,
                        decoration: InputDecoration(
                            labelText: "Tracking Id",
                            contentPadding: EdgeInsets.only(left: 20.w,
                                top: 20.w,
                                bottom: 20.w),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                            hintText: "e.g. 000000001",
                            labelStyle: TextStyle(fontWeight: FontWeight.bold,
                                fontFamily: 'Raleway')
                        ),
                        validator: (value) {
                          if (shipmentController.text.length > 5) {
                            return null;
                          }
                          return "Enter valid id";
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Center(
                      child: ElevatedButton(
                          child: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 30.w,
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets
                                  .symmetric(
                                  horizontal: 20.w, vertical: 5.h)),
                              backgroundColor: MaterialStateProperty.all(Colors
                                  .brown.shade400)
                          ),
                          onPressed: () async {
                            // Courier c = dummycouriers[0];
                            if (shipmentController.text.isNotEmpty) {
                              FocusScope.of(context).unfocus();
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      CourierHistoryTrackScreen(
                                        value: shipmentController.text)));
                              // PersistentNavBarNavigator.pushNewScreen(
                              //   context,
                              //   screen: TrackingDetails(),
                              //   withNavBar: false, // OPTIONAL VALUE. True by default.
                              //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              // );
                            }
                            else {
                              const snackBar = SnackBar(
                                content: Text('Enter Number'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar);
                            }
                            // if (_formKey.currentState!.validate()) {
                            //   _formKey.currentState?.save();
                            //   print("Requesting server for the courier status details..." +
                            //       shipmentNoController.text.toString());
                            //   showStatus(context, shipmentController.text);
                            // final snackdemo = SnackBar(
                            //   content: Text('Hii this is GFG\'s SnackBar'),
                            //   backgroundColor: Colors.red,
                            //   elevation: 10,
                            //   behavior: SnackBarBehavior.floating,
                            //   margin: EdgeInsets.only(bottom: 100.h)
                            // );
                            // ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>TrackingDetails()));
                            // await fetchCourierDetails(shipmentNoController.text, context);

                            // Navigator.of(context).pushNamed(
                            //   CourierStatus.routeName,
                            //   arguments: shipmentNoController.text.toString(),
                            // );
                          }
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 90.h, left: 10.w, right: 10.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                        child: Image.asset(
                          "assets/images/track_img.png",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
