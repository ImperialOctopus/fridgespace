import 'package:flutter/material.dart';
import 'fridge_page.dart';
import 'qr_page.dart';
import 'search_page.dart';

/// Screen containing main app pages.
class HomeScreen extends StatefulWidget {
  /// Screen containing main app pages.
  const HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex;

  static const List<Widget> _pages = <Widget>[
    QrPage(),
    FridgePage(),
    SearchPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Fridge',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Search',
          ),
        ],
        currentIndex: _pageIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
