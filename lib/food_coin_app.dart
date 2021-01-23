import 'package:flutter/material.dart';

import 'screen/home/home_screen.dart';
import 'theme/theme.dart';

/// Main app widget.
class FoodCoinApp extends StatefulWidget {
  /// Main app widget.
  const FoodCoinApp();

  @override
  State<StatefulWidget> createState() => _FoodCoinAppState();
}

class _FoodCoinAppState extends State<FoodCoinApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const _AppView();
  }
}

/// Main app view that consumes blocs.
class _AppView extends StatelessWidget {
  /// Const constructor.
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodCoin',
      theme: themeData,
      home: const HomeScreen(),
    );
  }
}
