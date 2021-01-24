import 'package:flutter/material.dart';

/// Error screen for a firebase error.
class FirebaseErrorScreen extends StatelessWidget {
  /// Error screen for a firebase error.
  const FirebaseErrorScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('An error has occurred.'),
        ),
      ),
    );
  }
}
