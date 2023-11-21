import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joy_of_speed/fragments/active_fragment.dart';
import 'package:joy_of_speed/fragments/completed_fragment.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class YourCouriersScreen extends StatefulWidget {
  const YourCouriersScreen({Key? key}) : super(key: key);

  @override
  State<YourCouriersScreen> createState() => _YourCouriersScreenState();
}

class _YourCouriersScreenState extends State<YourCouriersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6ab36).withOpacity(0.8),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 60.h,left:30.w),
            child: Text(
              "Courier History",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.w,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: Material(
              child: TabBar(
                tabs: [
                  Tab(
                    text: "Active",
                  ),
                  Tab(
                    text: "Completed",
                  ),
                ],
                labelStyle: TextStyle(
                    fontSize: 17.w
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                unselectedLabelStyle: TextStyle(fontSize: 17.w),
                indicator: RectangularIndicator(
                    bottomLeftRadius: 15.w,
                    bottomRightRadius:15.w,
                    topLeftRadius: 15.w,
                    topRightRadius: 15.w,
                    color: Colors.brown
                ),
                controller: _tabController,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: TabBarView(
                children: [
                  ActiveFragment(),
                  CompletedFragment()
                ],
                controller: _tabController,
              ),
            ),
          ),
        ],
      ),

    );
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
