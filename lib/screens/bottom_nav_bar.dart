import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:interrupt/screens/profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = [
    const Center(
      child: Text("Home"),
    ),
    const Center(
      child: Text("Hello"),
    ),
    const Center(
      child: Text("Hello"),
    ),
    const Profile(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
              label: 'Memories',
              icon: FaIcon(FontAwesomeIcons.baby),
            ),
            BottomNavigationBarItem(
              label: 'Documents',
              icon: FaIcon(FontAwesomeIcons.paperclip),
            ),
            BottomNavigationBarItem(
              label: 'Feeds',
              icon: FaIcon(FontAwesomeIcons.database),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: FaIcon(FontAwesomeIcons.gear),
            ),
          ]),
    );
  }
}