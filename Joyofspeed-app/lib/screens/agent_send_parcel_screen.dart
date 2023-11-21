import 'dart:convert';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:im_stepper/stepper.dart';
import 'package:joy_of_speed/screens/agent_home_screen.dart';
import 'package:joy_of_speed/screens/agent_start_screen.dart';
import 'package:joy_of_speed/screens/home_screen.dart';
import 'package:joy_of_speed/screens/search_place_screen.dart';
import 'package:joy_of_speed/widget.dart.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'class/location.dart';

const kTileHeight = 50.0;

const completeColor = Color(0xff5e6172);
const inProgressColor = Color(0xff5ec792);
const todoColor = Color(0xffd1d2d7);

class AgentSendParcelScreen extends StatefulWidget {
  const AgentSendParcelScreen({Key? key}) : super(key: key);

  @override
  State<AgentSendParcelScreen> createState() => _AgentSendParcelScreenState();
}

class _AgentSendParcelScreenState extends State<AgentSendParcelScreen> {
  TextEditingController _receiverNameController = TextEditingController();
  TextEditingController _receiverNumberController = TextEditingController();
  TextEditingController _receiverAddressController = TextEditingController();
  TextEditingController _receiverPincodeController = TextEditingController();
  TextEditingController _receiverCityController = TextEditingController();
  TextEditingController _receiverStateController = TextEditingController();
  TextEditingController _parcelTitleController = TextEditingController();
  TextEditingController _approxWeightController = TextEditingController();
  TextEditingController _amountReceived = TextEditingController();
  TextEditingController _senderNameController = TextEditingController();
  TextEditingController _senderNumberController = TextEditingController();
  TextEditingController _senderAddressController = TextEditingController();
  TextEditingController _senderPincodeController = TextEditingController();
  TextEditingController _senderCityController = TextEditingController();
  TextEditingController _senderStateController = TextEditingController();

  late Razorpay _razorpay;

  var itemsSub = [
    'Mobile',
    'Electronics',
    'Others',
  ];
  var items = [
    'Documents',
    'Parcel',
    'Large Box',
  ];

  bool _isOtpValid = false;
  String dropdownValueSub = "Mobile";
  int _processIndex = 0;
  String _selectedValue = 'Document';
  String userOrderID = '';
  List<Locations> locations = [];
  String status = '';

  String? _currentAddress;
  Position? _currentPosition;
  String dropdownValue = "Documents";

  _getLocations(pincode) async {
    setState(() {
      status = 'Please wait...';
    });
    final JsonDecoder _decoder = const JsonDecoder();
    await Requests.get("http://www.postalpincode.in/api/pincode/$pincode")
        .then((response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }

      setState(() {
        var json = _decoder.convert(res);
        var tmp = json['PostOffice'] as List;
        locations =
            tmp.map<Locations>((json) => Locations.fromJson(json)).toList();
        status = 'All Locations at Pincode ' + pincode;
      });
    });
  }

  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print(userOrderID);
    print(response.paymentId);
    print(response.orderId);
    print(response.signature);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountType = await prefs.getString('type') ?? 'user';
    if (accountType == 'user') {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }));
    } else if (accountType == 'agent') {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AgentHomeScreen();
      }));
    }
    // var order = await Requests.put('http://64.227.160.250/api/parcel/update-payment',
    //     body: {
    //       'orderID': userOrderID,
    //       'paymentPayID': response.paymentId,
    //       'paymentOrderID': response.orderId,
    //       'razorSign': response.signature,
    //     },
    //     bodyEncoding: RequestBodyEncoding.FormURLEncoded);
    // order.raiseForStatus();
    // dynamic orderID = order.json();
    // if(orderID['success']){
    //   Fluttertoast.showToast(
    //       msg: "SUCCESS: " + response.paymentId.toString(), timeInSecForIosWeb: 4);
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    // }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + "Payment Declined", timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName.toString(),
        timeInSecForIosWeb: 4);
  }

  void placeOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = await prefs.getString('userID') ?? '';
    String? accountType = await prefs.getString('type') ?? 'user';
    var r = await Requests.post('http://64.227.160.250/api/parcel',
        body: {
          'userId': userID,
          'accountType': accountType,
          'amountReceived':_amountReceived.text,
          'amount':'200',
          'senderName': _senderNameController.text,
          'senderNumber': _senderNumberController.text,
          'senderAddress': _senderAddressController.text,
          'senderCity': _senderCityController.text,
          'senderState': _senderStateController.text,
          'senderZip': _senderPincodeController.text,
          'recipientName': _receiverNameController.text,
          'recipientNumber': _receiverNumberController.text,
          'recipientAddress': _receiverAddressController.text,
          'recipientCity': _receiverCityController.text,
          'recipientState': _receiverStateController.text,
          'recipientZip': _receiverPincodeController.text,
          'name': _parcelTitleController.text,
          'weight': _approxWeightController.text,
          'type': _selectedValue,
          'shippingMethod': 'express'
        },
        bodyEncoding: RequestBodyEncoding.FormURLEncoded);
    r.raiseForStatus();
    dynamic json = r.json();
    if (json.containsKey('_id')) {
      userOrderID = json!['_id'];
      await AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.w),
          descTextStyle:TextStyle(fontWeight: FontWeight.w400,fontSize: 15.w),
          animType: AnimType.bottomSlide,
          title: 'Courier Generated',
          autoDismiss: true,
          autoHide: Duration(seconds: 2)
      ).show();
      String? accountType = await prefs.getString('type') ?? 'user';
      if (accountType == 'user') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      } else if (accountType == 'agent') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AgentStartScreen();
        }));
      }
      // var order =
      //     await Requests.post('http://64.227.160.250/api/parcel/create-payment',
      //         body: {
      //           'orderID': json!['_id'],
      //           'price': 20000,
      //         },
      //         bodyEncoding: RequestBodyEncoding.FormURLEncoded);
      // order.raiseForStatus();
      // dynamic orderID = order.json();
      // if (orderID['success']) {
      //   var options = {
      //     'key': 'rzp_test_Vq3soBihumh2hb',
      //     'amount': 20000,
      //     'name': 'Joy Of Speed',
      //     'order_id': orderID['orderID'],
      //     // Generate order_id using Orders API
      //     'description': 'Payment for Parcel',
      //     'retry': {'enabled': true, 'max_count': 1},
      //     // 'prefill': {'contact': "9876543210", 'email': "sameer@joyofspeed.com"},
      //     'external': {
      //       'wallets': ['paytm']
      //     }
      //   };
      //   try {
      //     _razorpay.open(options);
      //   } catch (e) {
      //     debugPrint(e.toString());
      //   }
      // }
    }
  }

  Widget handleScreen(screen) {
    if (screen == 0) {
      return Expanded(
        child: Visibility(
          visible: _processIndex == 0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            margin: EdgeInsets.only(
                left: 10.w, right: 10.w, bottom: 10.h, top: 10.h),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Container(
                    margin: EdgeInsets.only(top: 20.h),
                    child: Text(
                      "Sender Details",
                      style: TextStyle(
                          color: Colors.brown,
                          fontSize: 18.w,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'),
                    ),
                  )),
                  SizedBox(
                    height: 10.h,
                  ),
                  labelText("Sender Name"),
                  forms(controller: _senderNameController, choice: "Alpha"),
                  labelText("Contact Number"),
                  forms(controller: _senderNumberController, choice: "Number"),
                  labelText("Complete Address"),
                  Container(
                    margin: EdgeInsets.only(top: 4.h, left: 20.w, right: 20.w),
                    child: TextFormField(
                      controller: _senderAddressController,
                      keyboardType: TextInputType.text,
                      maxLines: 2,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 15.h),
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color(0xff8d8d8d),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIconColor: Color(0xff4f4f4f),
                        filled: true,
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        bool permission = await handleLocationPermission();
                        Fluttertoast.showToast(
                            msg: "Please Wait", timeInSecForIosWeb: 6);
                        if (permission) {
                          await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high)
                              .then((Position position) {
                            setState(() => _currentPosition = position);
                          }).catchError((e) {
                            debugPrint(e);
                          });
                          print(_currentPosition!.latitude);
                          print(_currentPosition!.longitude);
                          await placemarkFromCoordinates(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude)
                              .then((List<Placemark> placemarks) {
                            Placemark place = placemarks[0];
                            setState(() async {
                              _currentAddress =
                                  '${place.street}, ${place.subLocality},';
                              _senderAddressController.text =
                                  _currentAddress.toString();
                              _senderPincodeController.text =
                                  place.postalCode.toString();
                              _senderCityController.text =
                                  place.subAdministrativeArea.toString();
                              _senderStateController.text =
                                  place.administrativeArea.toString();
                              // await _getLocations(joy.pincodeController.text);
                              // final Locations location = locations.elementAt(1);
                            });
                          }).catchError((e) {
                            debugPrint(e);
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "Permission Declined",
                              timeInSecForIosWeb: 4);
                        }
                      },
                      child: Container(
                        width: 190.w,
                        margin: EdgeInsets.only(top: 10.h),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue.shade200),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.navigation),
                            Expanded(
                              child: Text(
                                "Get Current Location",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.w),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  labelText("Pincode"),
                  Container(
                    width: 300.w,
                    margin: EdgeInsets.only(top: 7.h, left: 20.w, right: 20.w),
                    child: TextFormField(
                      controller: _senderPincodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 15.h),
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color(0xff8d8d8d),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIconColor: Color(0xff4f4f4f),
                        filled: true,
                      ),
                      validator: (value) {
                        if (_senderPincodeController.text.length == 6) {
                          return null;
                        }
                        return "Enter Valid Pincode";
                      },
                      onChanged: (value) async {
                        if (value.length == 6) {
                          await _getLocations(value);
                          FocusScope.of(context).unfocus();
                          const snackBar = SnackBar(
                            content: Text('Please Wait'),
                            duration: Duration(seconds: 1),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          final Locations location = locations.elementAt(1);
                          setState(() {
                            _senderCityController.text = location.district;
                            _senderStateController.text = location.state;
                          });
                        }
                      },
                    ),
                  ),
                  labelText("City"),
                  forms(controller: _senderCityController, choice: "Alpha"),
                  labelText("State"),
                  forms(controller: _senderStateController, choice: "Alpha"),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (screen == 1) {
      return Expanded(
        child: Visibility(
          visible: _processIndex == 1,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            margin: EdgeInsets.only(
                left: 10.w, right: 10.w, bottom: 10.h, top: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                  margin: EdgeInsets.only(top: 20.h),
                  child: Text(
                    "Parcel Details",
                    style: TextStyle(
                        color: Colors.brown,
                        fontSize: 18.w,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway'),
                  ),
                )),
                SizedBox(
                  height: 10.h,
                ),
                labelText("Parcel Title"),
                forms(controller: _parcelTitleController, choice: "alpha"),
                labelText("Approx Weight"),
                forms(controller: _approxWeightController, choice: "Number"),
                labelText("Product Type"),
                Container(
                  margin: EdgeInsets.only(top: 4.h, left: 20.w, right: 20.w),
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.w),
                      color: Colors.grey.shade200),
                  width: 300.w,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: dropdownValue,
                      borderRadius: BorderRadius.all(Radius.circular(20.w)),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: TextStyle(
                                fontFamily: 'Raleway', color: Colors.black54),
                          ),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                dropdownValue!='Documents'?labelText("Product Sub Type"):Container(),
                dropdownValue!='Documents'?Container(
                  margin: EdgeInsets.only(top: 4.h, left: 20.w, right: 20.w),
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.w),
                      color: Colors.grey.shade200),
                  width: 300.w,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: dropdownValueSub,
                      borderRadius: BorderRadius.all(Radius.circular(20.w)),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: itemsSub.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: TextStyle(
                                fontFamily: 'Raleway', color: Colors.black54),
                          ),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                    ),
                  ),
                ):Container(),
              ],
            ),
          ),
        ),
      );
    }
    else if (screen == 2) {
      return Expanded(
        child: Visibility(
          visible: _processIndex == 2,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            margin: EdgeInsets.only(
                left: 10.w, right: 10.w, bottom: 10.h, top: 10.h),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Container(
                    margin: EdgeInsets.only(top: 20.h),
                    child: Text(
                      "Receiver Details",
                      style: TextStyle(
                          color: Colors.brown,
                          fontSize: 18.w,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'),
                    ),
                  )),
                  SizedBox(
                    height: 10.h,
                  ),
                  labelText("Receiver Name"),
                  forms(controller: _receiverNameController, choice: "Alpha"),
                  labelText("Contact Number"),
                  forms(
                      controller: _receiverNumberController, choice: "Number"),
                  labelText("Complete Address"),
                  Container(
                    margin: EdgeInsets.only(top: 4.h, left: 20.w, right: 20.w),
                    child: TextFormField(
                      controller: _receiverAddressController,
                      keyboardType: TextInputType.text,
                      maxLines: 2,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 15.h),
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color(0xff8d8d8d),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIconColor: Color(0xff4f4f4f),
                        filled: true,
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        var response = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPlaceScreen()));
                        print(response);
                        setState(() {
                          _receiverPincodeController.text =
                              response['postalCode'];
                          _receiverAddressController.text = response['address'];
                          _receiverCityController.text = response['area'];
                          _receiverStateController.text = response['aArea'];
                        });
                      },
                      child: Container(
                        width: 170.w,
                        margin: EdgeInsets.only(top: 10.h),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue.shade200),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.navigation),
                            Text(
                              "Search Location",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.w),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  labelText("Pincode"),
                  Container(
                    margin: EdgeInsets.only(top: 7.h, left: 20.w, right: 20.w),
                    child: TextFormField(
                      controller: _receiverPincodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 15.h),
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color(0xff8d8d8d),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIconColor: Color(0xff4f4f4f),
                        filled: true,
                      ),
                      validator: (value) {
                        if (_receiverPincodeController.text.length == 6) {
                          return null;
                        }
                        return "Enter Valid Pincode";
                      },
                      onChanged: (value) async {
                        if (value.length == 6) {
                          await _getLocations(value);
                          FocusScope.of(context).unfocus();
                          const snackBar = SnackBar(
                            content: Text('Please Wait'),
                            duration: Duration(seconds: 1),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          final Locations location = locations.elementAt(1);
                          setState(() {
                            _receiverCityController.text = location.district;
                            _receiverStateController.text = location.state;
                          });
                        }
                      },
                    ),
                  ),
                  labelText("City"),
                  forms(controller: _receiverCityController, choice: "Alpha"),
                  labelText("State"),
                  forms(controller: _receiverStateController, choice: "Alpha"),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }else if (screen == 3) {
      return Expanded(
        child: Visibility(
          visible: _processIndex == 3,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
            ),
            margin: EdgeInsets.only(
                left: 10.w, right: 10.w, bottom: 10.h, top: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 20.h),
                      child: Text("Payment Details", style: TextStyle(
                          color: Colors.brown,
                          fontSize: 18.w,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'
                      ),),
                    )
                ),
                labelText("Minimum Amount: \u{20B9}200"),
                SizedBox(height: 10.h,),
                labelText("Payment Received"),
                forms(controller: _amountReceived, choice: "Number"),
                SizedBox(height: 20.h,),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6ab36),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Send Courier"),
        toolbarHeight: 45.h,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xfff6ab36).withOpacity(0.9),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              children: [
                IconStepper(
                  activeStepColor: Colors.brown.shade400,
                  lineLength: 30.w,
                  activeStepBorderColor: Colors.brown,
                  activeStepBorderWidth: 1,
                  stepRadius: 22.w,
                  stepColor: Colors.black12,
                  enableNextPreviousButtons: false,
                  enableStepTapping: false,
                  icons: [
                    Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ),
                    Icon(Icons.card_giftcard, color: Colors.white),
                    Icon(Icons.local_shipping, color: Colors.white),
                    Icon(Icons.payment, color: Colors.white),
                  ],
                  activeStep: _processIndex,
                  onStepReached: (index) {
                    setState(() {
                      _processIndex = index;
                    });
                  },
                ),
                handleScreen(_processIndex),
                // Visibility(
                //   visible: _processIndex==3,
                //   child: Card(
                //     color: Colors.white,
                //     child: Padding(
                //       padding: EdgeInsets.all(24.0),
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         crossAxisAlignment: CrossAxisAlignment.stretch,
                //         children: [
                //           Text(
                //             'Sender Details',
                //             style: TextStyle(
                //               fontSize: 24.0,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           SizedBox(height: 24.0),
                //           TextField(
                //             keyboardType: TextInputType.number,
                //             decoration: InputDecoration(
                //               labelText: 'Pincode',
                //               hintText: '',
                //             ),
                //             maxLength: 8,
                //             onChanged: (value) {
                //             },
                //           ),
                //           TextField(
                //             keyboardType: TextInputType.name,
                //             decoration: InputDecoration(
                //               labelText: 'City',
                //               hintText: '',
                //             ),
                //             onChanged: (value) {
                //             },
                //           ),
                //           TextField(
                //             keyboardType: TextInputType.number,
                //             decoration: InputDecoration(
                //               labelText: 'State',
                //               hintText: '',
                //             ),
                //             onChanged: (value) {
                //             },
                //           ),
                //           SizedBox(height: 24.0),
                //           Row(
                //             children: [
                //               Expanded(
                //                 child: ElevatedButton(
                //                   onPressed: _isOtpValid ? () {
                //                     // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                //                   } : null,
                //                   child: Text('Previous'),
                //                 ),
                //               ),
                //               SizedBox(width: 10,),
                //               Expanded(
                //                 child: ElevatedButton(
                //                   onPressed: _isOtpValid ? () {
                //                     // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                //                   } : null,
                //                   child: Text('Next'),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    previousButton(),
                    _processIndex == 3 ? submitButton(context) : nextButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the next button.
  Widget nextButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      width: 140.w,
      height: 50.w,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.brown)),
        onPressed: () {
          if (_processIndex == 0) {
            if (_senderNameController.text.isEmpty ||
                _senderNumberController.text.isEmpty ||
                _senderAddressController.text.isEmpty ||
                _senderStateController.text.isEmpty ||
                _senderCityController.text.isEmpty ||
                _senderPincodeController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please Fill all the details");
            } else {
              setState(() {
                _processIndex++;
              });
            }
          } else if (_processIndex == 1) {
            if (_parcelTitleController.text.isEmpty ||
                _approxWeightController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please Fill all the details");
            } else {
              setState(() {
                _processIndex++;
              });
            }
          } else if (_processIndex == 2) {
            if (_receiverNameController.text.isEmpty ||
                _receiverNumberController.text.isEmpty ||
                _receiverAddressController.text.isEmpty ||
                _receiverStateController.text.isEmpty ||
                _receiverCityController.text.isEmpty ||
                _receiverPincodeController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please Fill all the details");
            } else {
              setState(() {
                _processIndex++;
              });
            }
          }

          // if (activeStep < upperBound) {
          //   setState(() {
          //     activeStep++;
          //   });
          // }
        },
        child: Text('Next'),
      ),
    );
  }

  Widget submitButton(context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      width: 140.w,
      height: 50.w,
      child: ElevatedButton(
        style:
            ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
        onPressed: () {
          if (_processIndex == 3) {
            placeOrder();
          }
        },
        child: Text('Submit'),
      ),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      width: 140.w,
      height: 50.w,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.brown)),
        onPressed: () {
          // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
          if (_processIndex > 0) {
            setState(() {
              _processIndex--;
            });
          }
        },
        child: Text('Prev'),
      ),
    );
  }
}

/// hardcoded bezier painter
/// TODO: Bezier curve into package component
class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius,
            radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius,
            radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}

final _processes = ['Prospect', 'Tour', 'Offer'];
