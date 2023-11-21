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
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Color(0xfff6ab36),
        title: Text(
          'Courier History',
          style: TextStyle(
              fontSize: 18.w,
              fontFamily: 'Raleway',
              letterSpacing: 1.4
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20.h,
            ),
            Material(
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
            Expanded(
              child: TabBarView(
                children: [
                  ActiveFragment(),
                  CompletedFragment()
                ],
                controller: _tabController,
              ),
            ),

          ],
        ),
      ),

    );
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
