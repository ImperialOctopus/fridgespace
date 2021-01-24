import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/database/firebase_database_repository.dart';
import '../../repository/database/database_repository.dart';
import 'fridge_page.dart';
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

  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  static const List<Widget> _pages = <Widget>[
    FridgePage(),
    SearchPage(),
  ];

  static const List<BottomNavigationBarItem> _bottomNavigationBarItems =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Fridge',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bubble_chart),
      label: 'Bubble',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _onPageChanged(index);
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        items: _bottomNavigationBarItems,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        // TODO: barcode scanning
        onPressed: () {},
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    });
  }
}
