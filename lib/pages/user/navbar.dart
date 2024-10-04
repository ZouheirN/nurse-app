import 'package:flutter/material.dart';
import 'package:nurse_app/pages/user/history_page.dart';
import 'package:nurse_app/pages/user/home_page.dart';
import 'package:nurse_app/pages/user/settings_page.dart';
import 'package:nurse_app/pages/user/social_profiles_page.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int myIndex = 0;
  List<Widget> widgetList = [
    const HomePage(),
    const HistoryPage(),
    SocialProfilesPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetList[myIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 30,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.home,
              size: 30,
              color: Color(0xFF7BB442),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_outlined,
              size: 30,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.notifications,
              size: 30,
              color: Color(0xFF7BB442),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info_outline,
              size: 30,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.info,
              size: 30,
              color: Color(0xFF7BB442),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 30,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.person,
              size: 30,
              color: Color(0xFF7BB442),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
