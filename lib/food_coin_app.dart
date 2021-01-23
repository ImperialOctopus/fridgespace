import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodcoin/bloc/authentication/authentication_event.dart';

import 'bloc/authentication/authentication_bloc.dart';
import 'screen/firebase_error_screen.dart';
import 'screen/home/home_screen.dart';
import 'screen/loading/loading_screen.dart';
import 'screen/login/login_screen.dart';
import 'theme/theme.dart';

/// Main app widget.
class FoodCoinApp extends StatelessWidget {
  /// Main app widget.
  FoodCoinApp();

  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodCoin',
      theme: themeData,
      home: SafeArea(
        child: FutureBuilder(
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
      ),
    );
  }
}

/// Main app view.
class _AppView extends StatefulWidget {
  /// Const constructor.
  const _AppView();

  @override
  __AppViewState createState() => __AppViewState();
}

class __AppViewState extends State<_AppView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) =>
          AuthenticationBloc()..add(const AuthenticationAppStarted()),
      child: Navigator(
        initialRoute: '/login',
        onGenerateRoute: (settings) {
          if (settings.name == '/login') {
            return MaterialPageRoute<void>(
                builder: (context) => const LoginScreen());
          }
          if (settings.name == '/') {
            return MaterialPageRoute<void>(
                builder: (context) => const HomeScreen());
          }

          throw FallThroughError();
        },
      ),
    );
  }
}
