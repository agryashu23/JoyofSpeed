import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joy_of_speed/screens/send_parcel_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:joy_of_speed/screens/shop_near_me_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  double? lat;
  double? lang;
  String? name ='User';


  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
          msg: "Location services are disabled. Please enable the services", timeInSecForIosWeb: 4);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Location permissions are denied", timeInSecForIosWeb: 4);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Location permissions are permanently denied, we cannot request permissions.", timeInSecForIosWeb: 4);
      return false;
    }
    return true;
  }


  @override
  void initState() {
    super.initState();
    handleData();
  }

  void handleData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? nameT = await prefs.getString('name')??'User';

    setState(() {
      name = nameT;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6ab36).withOpacity(0.8),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 70.h, left: 30.w),
                    child: Text(
                      "Hi, $name",
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
              Container(
                margin: EdgeInsets.only(top: 70.h, right: 10.w),
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 70.h,
                  width: 70.w,
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 30.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25)),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 25.h, left: 30.w),
                    child: Text(
                      "What are you looking for today?",
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 18.w,
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
                            Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (context) => SendParcelScreen()));
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 20.h),
                              width: 90.w,
                              height: 80.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: Color(0xfff6ab36).withOpacity(0.8),
                              ),
                              child: Icon(
                                Icons.card_giftcard,
                                size: 50.w,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            bool permission = await handleLocationPermission();
                            Fluttertoast.showToast(
                              msg: "Please Wait", timeInSecForIosWeb: 4,
                              toastLength: Toast.LENGTH_LONG,

                            );
                            if (permission) {
                              await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high)
                                  .then((Position position) {
                                setState(() {
                                  lat = position.latitude;
                                  lang = position.longitude;
                                });
                              }).catchError((e) {
                                debugPrint(e);
                              });
                              Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                      builder: (context) => ShopNearMeScreen(latitude:lat!,longitude:lang!)));
                            }

                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 20.h),
                              width: 90.w,
                              height: 80.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: Color(0xfff6ab36).withOpacity(0.8),
                              ),
                              child: Icon(
                                Icons.shop_2,
                                size: 40.w,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      // Center(
                      //   child: GestureDetector(
                      //     onTap: (){
                      //       PersistentNavBarNavigator.pushNewScreen(
                      //         context,
                      //         screen:CheckPrice(),
                      //         withNavBar: false, // OPTIONAL VALUE. True by default.
                      //         pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      //       );
                      //     },
                      //     child: Container(
                      //       margin: EdgeInsets.only(top: 20.h),
                      //       width: 90.w,
                      //       height: 80.h,
                      //       alignment: Alignment.center,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(25.0),
                      //         color: Color(0xfff6ab36).withOpacity(0.8),
                      //       ),
                      //       child: Icon(Icons.price_change,size: 40.w,color: Colors.white,)
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 5.h, left: 10.w),
                            alignment: Alignment.center,
                            child: Text(
                              "Send Parcel",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.w,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                      Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 5.h, left: 10.w),
                            alignment: Alignment.center,
                            child: Text(
                              "Shops near you",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.w,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                      // Center(
                      //   child: Container(
                      //       margin: EdgeInsets.only(top: 5.h,left: 10.w),
                      //       alignment: Alignment.center,
                      //       child: Text("Check Price", style: TextStyle(
                      //         color: Colors.grey,
                      //         fontSize: 14.w,
                      //         fontWeight: FontWeight.bold,
                      //       ),)
                      //   ),
                      // ),
                    ],
                  ),
                  Container(
                    margin:
                    EdgeInsets.symmetric(vertical: 25.h, horizontal: 15.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        "assets/images/home_ad2.jpg",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
