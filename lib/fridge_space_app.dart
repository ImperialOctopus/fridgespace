import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/authentication/authentication_bloc.dart';
import 'bloc/authentication/authentication_event.dart';
import 'bloc/authentication/authentication_state.dart';
import 'screen/firebase_error_screen.dart';
import 'screen/home/home_screen.dart';
import 'screen/loading/loading_screen.dart';
import 'screen/login/login_screen.dart';
import 'service/google_login_service.dart';
import 'theme/theme.dart';

/// Main app widget.
class FridgeSpaceApp extends StatelessWidget {
  /// Main app widget.
  FridgeSpaceApp();

  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fridge Space',
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
              return const _ProviderComponent();
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
class _ProviderComponent extends StatefulWidget {
  /// Const constructor.
  const _ProviderComponent();

  @override
  _ProviderComponentState createState() => _ProviderComponentState();
}

class _ProviderComponentState extends State<_ProviderComponent> {
  AuthenticationBloc _authenticationBloc;

  GoogleLoginService _googleLoginService;

  @override
  void initState() {
    super.initState();

    _authenticationBloc = AuthenticationBloc()
      ..add(const AuthenticationAppStarted());
    _googleLoginService = GoogleLoginService();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GoogleLoginService>.value(value: _googleLoginService)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>.value(value: _authenticationBloc)
        ],
        child: _AppView(),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is UserAuthenticated) {
          return HomeScreen(user: state.user);
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}