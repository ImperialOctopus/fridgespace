import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screen/firebase_error_screen.dart';
import 'screen/home/home_screen.dart';
import 'screen/loading_screen.dart';
import 'theme/theme.dart';

/// Main app widget.
class FoodCoinApp extends StatefulWidget {
  /// Main app widget.
  const FoodCoinApp();

  @override
  State<StatefulWidget> createState() => _FoodCoinAppState();
}

class _FoodCoinAppState extends State<FoodCoinApp> {
  Future<FirebaseApp> _firebaseApp;

  @override
  void initState() {
    super.initState();
    _firebaseApp = Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodCoin',
      theme: themeData,
      home: FutureBuilder(
        // Initialize firebase
        future: _firebaseApp,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return const FirebaseErrorScreen();
          }

          // Loading complete
          if (snapshot.connectionState == ConnectionState.done) {
            return const _AppView();
          }

          // Future hasn't completed
          return const LoadingScreen();
        },
      ),
    );
  }
}

/// Main app view.
class _AppView extends StatelessWidget {
  /// Const constructor.
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
