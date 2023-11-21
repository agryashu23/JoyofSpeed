import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joy_of_speed/screens/client_couriers_screen.dart';
import 'package:joy_of_speed/screens/client_home_screen.dart';
import 'package:joy_of_speed/screens/delivery_home_screen.dart';
import 'package:joy_of_speed/screens/delivery_notifications_screen.dart';


class ClientStartScreen extends StatefulWidget {
  const ClientStartScreen({Key? key}) : super(key: key);

  @override
  State<ClientStartScreen> createState() => _ClientStartScreenState();
}

class _ClientStartScreenState extends State<ClientStartScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    ClientHomeScreen(),
    YourCouriersScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor:Color(0xfff6ab36) ,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.track_changes_outlined),
                label: "Home",
                backgroundColor: Colors.green
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: "History",
                backgroundColor: Colors.yellow
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          iconSize: 30.w,
          onTap: _onItemTapped,
          elevation: 5
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}