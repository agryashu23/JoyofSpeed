import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RaiseQueryScreen extends StatefulWidget {
  const RaiseQueryScreen({Key? key}) : super(key: key);

  @override
  State<RaiseQueryScreen> createState() => _RaiseQueryScreenState();
}

class _RaiseQueryScreenState extends State<RaiseQueryScreen> {
  TextEditingController subjectController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();
  String dropdownValue = "Select Type";
  String dropdownValueOrder = 'Select Order';

  List<String> itemsOrder = [];

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
      List<String> _queries = [];
      _queries.add('Select Order');
      for (int i = 0; i < orderID.length; i++) {
        if (orderID[i]['status'] != 'delivered') {
          _queries.add('00000000'+orderID[i]['orderShownID'].toString());
        }
      }
      setState(() {
        itemsOrder.addAll(_queries);
      });
    }catch(e){}
  }

  @override
  void initState() {
    super.initState();
    getQueries();
  }


  var items = [
    'Select Type',
    'Technicial',
    'Delivery Person',
    'Agent',
    'Payment',
    'Other',
  ];

  void submitQuery()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = await prefs.getString('userID')??'';
    var order = await Requests.post('http://64.227.160.250/api/query',
        body: {
          'user':userID,
          'type':dropdownValue,
          'orderID':dropdownValueOrder.replaceAll('00000000',''),
          'subject': subjectController.text,
          'message': messageController.text,
        },
    bodyEncoding: RequestBodyEncoding.FormURLEncoded);
    order.raiseForStatus();
    dynamic orderID = order.json();
    print(orderID);
    AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.w),
        descTextStyle:TextStyle(fontWeight: FontWeight.w400,fontSize: 15.w),
        animType: AnimType.bottomSlide,
        title: 'Queries Raised',
        desc: 'Your Ticket number is: 94yd84jdk',
        autoDismiss: true,
        autoHide: Duration(seconds: 2)
    ).show();
    setState(() {
      subjectController.text ="";
      dropdownValue = "Select";
      messageController.text="";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Raise Your Queries"),
          centerTitle: true,
          backgroundColor: Color(0xfff6ab36).withOpacity(0.9),
        ),
        body: Column(
          children: [
            Center(
              child: Container(
                  height: 80.h,
                  width: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  margin: EdgeInsets.only(top: 20.h),
                  child: Image.asset('assets/images/logowithname.jpg')),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
              child: TextFormField(
                controller: subjectController,
                autofocus: false,
                decoration: InputDecoration(
                    labelText: "Subject",
                    contentPadding:
                    EdgeInsets.only(left: 20.w, top: 15.w, bottom: 15.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    hintText: "Enter the Subject",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'Raleway')),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(10.w)),
              width: 320.w,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: dropdownValue,
                  borderRadius: BorderRadius.all(Radius.circular(20.w)),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items,style: TextStyle(fontFamily: 'Raleway',color: Colors.black54),),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(10.w)),
              width: 320.w,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: dropdownValueOrder,
                  borderRadius: BorderRadius.all(Radius.circular(20.w)),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: itemsOrder.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items,style: TextStyle(fontFamily: 'Raleway',color: Colors.black54),),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValueOrder = newValue!;
                    });
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
              child: TextFormField(
                controller: messageController,
                autofocus: false,
                textAlign: TextAlign.center,
                maxLength: 150,
                maxLines: 4,
                decoration: InputDecoration(
                    labelText: "Message",
                    contentPadding:
                    EdgeInsets.only(left: 20.w, top: 15.w, bottom: 15.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    hintText: "Enter the Message",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'Raleway')),
              ),
            ),
            GestureDetector(
              onTap: (){
                if(subjectController.text.isNotEmpty && messageController.text.isNotEmpty && dropdownValue!="Select Type" && dropdownValue!="Select Order"){
                  submitQuery();
                }
                else{
                  const snackBar = SnackBar(
                    content: Text('Please Enter All Fields'),duration: Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 45.h,
                width: 170.w,
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Submit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.0),
                  child: Text(
                    'OR',
                    style: TextStyle(
                        color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.0),
              child: Text(
                'Contact Us -',
                style: TextStyle(
                    color: Colors.black54, fontSize: 22.w,fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 60.h,
                  width: 60.w,
                  child: Image.asset('assets/images/whats_app.png'),
                ),
                Container(
                  height: 60.h,
                  width: 60.w,
                  child: Image.asset('assets/images/caller-remove.png'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

