import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:interrupt/screens/docs_gallery.dart';
import 'package:interrupt/screens/settings.dart';
import 'package:interrupt/screens/share.dart';
import 'package:interrupt/screens/upload_document.dart';
import 'package:provider/provider.dart';
import '../provider/memory_timeline.dart';
import '../provider/user_provider.dart';
import '../provider/expire_provider.dart';

import '../provider/verified_number_provider.dart';
import 'dashboard.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = [
    const DashboardScreen(),
    const DocsGalleryScreen(),
    const MemoryTimeline(),
    const Share(),
    const SettingsPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  fetchDocs() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.fetchUserDocs();
  }

  fetchExpire() async {
    ExpireProvider userProvider = Provider.of(context, listen: false);
    await userProvider.fetchExpiryDetails();
  }

  fetchNumbers() async {
    NumberProvider userProvider = Provider.of(context, listen: false);
    await userProvider.fetchAllNumber();
  }

  @override
  void initState() {
    super.initState();
    fetchDocs();
    fetchExpire();
    fetchNumbers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          selectedItemColor: const Color.fromRGBO(55, 80, 206, 1),
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(FontAwesomeIcons.atom),
            ),
            BottomNavigationBarItem(
              label: 'Memories',
              icon: FaIcon(FontAwesomeIcons.vault),
            ),
            BottomNavigationBarItem(
              label: 'Documents',
              icon: FaIcon(FontAwesomeIcons.baby),
            ),
            BottomNavigationBarItem(
              label: 'Feeds',
              icon: FaIcon(FontAwesomeIcons.share),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: FaIcon(FontAwesomeIcons.gear),
            ),
          ]),
    );
  }
}
