import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientWalletScreen extends StatefulWidget {
  const ClientWalletScreen({Key? key}) : super(key: key);

  @override
  State<ClientWalletScreen> createState() => _ClientWalletScreenState();
}

class _ClientWalletScreenState extends State<ClientWalletScreen> {
  int total = 0;
  int rTotal = 0;

  List<dynamic> items = [];

  void getQueries() async {
    print('Here2');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = await prefs.getString('userID') ?? '';
    try {
      var order =
          await Requests.get('http://64.227.160.250/api/parcel/${userID}',
              body: {
                'user': userID,
              },
              bodyEncoding: RequestBodyEncoding.FormURLEncoded);
      print('Here3');
      order.raiseForStatus();
      print('Her4');
      dynamic orderID = order.json();
      List _queries = [];
      int tAmount = 0;
      int rAmount = 0;
      for (int i = 0; i < orderID.length; i++) {
        rAmount = rAmount + int.parse(orderID[i]['amountReceived'].toString());
        tAmount = tAmount + int.parse(orderID[i]['amount'].toString());
        // if (orderID[i]['status'] != 'delivered') {
        //   print('Here');
        _queries.add(orderID[i]);
        // }
      }
      print('HERE5');
      setState(() {
        total = tAmount;
        rTotal = rAmount;
        items.addAll(_queries);
      });
    } catch (e) {
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
        title: Text("Wallet"),
        centerTitle: true,
        backgroundColor: Color(0xfff6ab36),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.account_balance_wallet_rounded))
        ],
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width-32,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage('assets/images/credit_card_background.png'),
                fit: BoxFit.contain,
              ),
            ),
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Available Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\u{20B9}100',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
  SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Earnings:",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold, fontSize: 14.w,),
                        ),
                        Text(
                          '\u{20B9}$rTotal',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.w,
                              color: Colors.white,
                              letterSpacing: 1.4),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Minimum Due:",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold, fontSize: 14.w,),
                        ),
                        Text(
                          '\u{20B9}$total',
                          style: TextStyle(

                              fontWeight: FontWeight.bold,
                              fontSize: 14.w,
                              color: Colors.white,
                              letterSpacing: 1.4),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Center(
            child: Text("Recent Transactions", style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20.w)),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: ListView(
                children: items.map((item) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    height: 70.h,
                    width: 340.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.brown.shade300,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text("Tracking No.- "+'00000000${item['orderShownID']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.w)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Text('\u{20B9}${item['amountReceived']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.w,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
