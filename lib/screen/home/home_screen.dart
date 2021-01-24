import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/component/barcode_dialog/barcode_dialog.dart';
import '../../exception/barcode_lookup_exception.dart';
import '../../model/product_lookup_result.dart';
import '../../service/qr_service.dart';
import '../add_item/add_item_screen.dart';
import '../join_bubble/join_bubble_screen.dart';
import 'bubbles_page.dart';
import 'feed_page.dart';
import 'fridge_page.dart';

/// Screen containing main app pages.
class HomeScreen extends StatefulWidget {
  /// Screen containing main app pages.
  const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex;

  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  static const List<Widget> _pages = <Widget>[
    FridgePage(),
    FeedPage(),
    BubblesPage(),
  ];

  static const List<BottomNavigationBarItem> _bottomNavigationBarItems =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.kitchen),
      label: 'Fridge',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.star),
      label: 'Feed',
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
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            _onPageChanged(index);
          },
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        items: _bottomNavigationBarItems,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _buildFloatingActionButton(_pageIndex),
    );
  }

  Widget _buildFloatingActionButton(int pageIndex) {
    // QR page
    if (pageIndex == 0 || pageIndex == 1) {
      return FloatingActionButton(
        onPressed: _onAddFoodPressed,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      );
    }
    // Bubbles
    if (pageIndex == 2) {
      FloatingActionButton(
        onPressed: _onJoinBubblePressed,
        tooltip: 'Join Bubble',
        child: const Icon(Icons.add),
      );
    }
    throw FallThroughError();
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

  void _onAddFoodPressed() async {
    final file =
        await RepositoryProvider.of<QrService>(context).requestImageFile();

    // User cancelled file input.
    if (file == null) {
      return;
    }

    // Show dialog while waiting for barcode processing.
    final future = _processBarcodeFile(file);

    final userResult = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return BarcodeDialog(future: future);
      },
    );

    // User cancelled barcode checking, or no barcodes were found.
    if (userResult != true) {
      return;
    }

    ProductLookupResult lookup;
    try {
      lookup = await future;
    } catch (e) {
      lookup = null;
    }

    // Push add item page.
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => AddItemScreen(lookupResult: lookup),
      ),
    );
  }

  void _onJoinBubblePressed() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => const JoinBubbleScreen(),
      ),
    );
  }

  Future<ProductLookupResult> _processBarcodeFile(File file) async {
    final qrService = RepositoryProvider.of<QrService>(context);
    final barcodesList = await qrService.readBarcodes(file);

    if (barcodesList.isEmpty) {
      throw const BarcodeLookupException('No barcodes found in image');
    }

    final foodItems =
        (await Future.wait(barcodesList.map(qrService.lookupFoodItem)))
            .where((element) => element != null);

    if (foodItems.isEmpty) {
      throw const BarcodeLookupException(
          'Barcode could not be found in food database');
    }

    /// Return first of all valid items - probably not many cases where this will
    /// discard useful information.
    return foodItems.first;
  }
}
