import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/database/firebase_database_repository.dart';
import '../../repository/database/database_repository.dart';
import 'fridge_page.dart';
import 'qr_page.dart';
import 'search_page.dart';

/// Screen containing main app pages.
class HomeScreen extends StatelessWidget {
  /// Logged in user object.
  final User user;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<DatabaseRepository>(
      create: (context) => FirebaseDatabaseRepository(user: user),
      child: const _HomeScreenPages(),
    );
  }

  /// Screen containing main app pages.
  const HomeScreen({@required this.user});
}

class _HomeScreenPages extends StatefulWidget {
  /// Screen containing main app pages.
  const _HomeScreenPages();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreenPages> {
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
