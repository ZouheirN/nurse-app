import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/extensions/context_extension.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/pages/user/history_page.dart';
import 'package:nurse_app/pages/user/home_page.dart';
import 'package:nurse_app/pages/user/notifications_page.dart';
import 'package:nurse_app/pages/user/settings_page.dart';
import 'package:nurse_app/pages/user/social_profiles_page.dart';
import 'package:nurse_app/utilities/dialogs.dart';
import 'package:quickalert/quickalert.dart';

import '../../features/home/cubit/home_cubit.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int myIndex = 2; // Default to HomePage index
  List<Widget> widgetList = [
    const HistoryPage(),
    const NotificationsPage(
      showLeading: false,
    ),
    const HomePage(),
    SocialProfilesPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      bloc: HomeCubit()..getPopups(),
      listener: (context, state) {
        if (state is GetPopupsSuccess) {
          final popup = state.popups.popup;

          if (popup == null) return;

          Dialogs.showPopup(
            context: context,
            image: popup.image,
            title: popup.title,
            content: popup.content,
            type: popup.type,
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: widgetList[myIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF7BB442),
          unselectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7BB442),
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          currentIndex: myIndex,
          items: [
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/images/clipboard.png',
                  height: 25,
                  width: 25,
                ),
              ),
              activeIcon: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFF7BB442),
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/images/clipboard.png',
                  height: 25,
                  width: 25,
                ),
              ),
              label: context.localizations.requests,
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/images/notification2.png',
                  height: 25,
                  width: 25,
                ),
              ),
              activeIcon: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFF7BB442),
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/images/notification2.png',
                  height: 25,
                  width: 25,
                ),
              ),
              label: context.localizations.notifications,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/home2.png',
                height: 40,
                width: 80.27,
              ),
              activeIcon: Image.asset(
                'assets/images/home2s.png',
                height: 40,
                width: 80.27,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/images/info2.png',
                  height: 25,
                  width: 25,
                ),
              ),
              activeIcon: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFF7BB442),
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/images/info2.png',
                  height: 25,
                  width: 25,
                ),
              ),
              label: context.localizations.contact,
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/images/user.png',
                  height: 25,
                  width: 25,
                ),
              ),
              activeIcon: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFF7BB442),
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/images/user.png',
                  height: 25,
                  width: 25,
                ),
              ),
              label: context.localizations.profile,
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.home_outlined,
            //     size: 30,
            //     color: Colors.black,
            //   ),
            //   activeIcon: Icon(
            //     Icons.home,
            //     size: 30,
            //     color: Color(0xFF7BB442),
            //   ),
            //   label: '',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.notifications_outlined,
            //     size: 30,
            //     color: Colors.black,
            //   ),
            //   activeIcon: Icon(
            //     Icons.notifications,
            //     size: 30,
            //     color: Color(0xFF7BB442),
            //   ),
            //   label: '',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.info_outline,
            //     size: 30,
            //     color: Colors.black,
            //   ),
            //   activeIcon: Icon(
            //     Icons.info,
            //     size: 30,
            //     color: Color(0xFF7BB442),
            //   ),
            //   label: '',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.person_outline,
            //     size: 30,
            //     color: Colors.black,
            //   ),
            //   activeIcon: Icon(
            //     Icons.person,
            //     size: 30,
            //     color: Color(0xFF7BB442),
            //   ),
            //   label: '',
            // ),
          ],
        ),
      ),
    );
  }
}
