import 'package:flutter/material.dart';

/// Page with a simple loading indicator.
class LoadingPage extends StatelessWidget {
  /// Page with a simple loading indicator.
  const LoadingPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
