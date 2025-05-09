import 'package:allamvizsga/Screens/Mainscreens/Events/EventsScreen.dart';
import 'package:allamvizsga/Screens/Mainscreens/Places/PlacesScreen.dart';
import 'package:allamvizsga/Screens/Mainscreens/ProfileScreen/profile_screen.dart';
import 'package:allamvizsga/Screens/Mainscreens/Transport/TransportScreen.dart';
import 'package:flutter/material.dart';
import 'package:allamvizsga/screens/Mainscreens/News/news_screen.dart';

class MainScreen extends StatefulWidget {
  final String userId;

  const MainScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> screens;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    screens = [
      NewsScreen(),
      Events(userId: widget.userId),
      TransportScreen(),
      PlacesScreen(),
      ProfileScreen(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        selectedFontSize: 14,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(

            icon: Icon(Icons.newspaper_outlined),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Transport',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Places',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
