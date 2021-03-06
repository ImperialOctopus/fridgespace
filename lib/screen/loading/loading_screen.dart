import 'package:flutter/material.dart';

import 'loading_page.dart';

/// Screen to display while firebase loads.
class LoadingScreen extends StatelessWidget {
  /// Screen to display while firebase loads.
  const LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadingPage(),
    );
  }
}
