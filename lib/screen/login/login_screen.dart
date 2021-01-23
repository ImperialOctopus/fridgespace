import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_state.dart';
import '../loading/loading_page.dart';

/// Screen to show when app loads, before sign in.
class LoginScreen extends StatelessWidget {
  /// Screen to show when app loads, before sign in.
  const LoginScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: _onStateChanged,
        builder: (context, state) {
          if (state is UserNotAuthenticated) {
            return Center(
              child: RaisedButton(
                onPressed: _onLoginPressed,
                child: const Text('Log In'),
              ),
            );
          }
          return const LoadingPage();
        },
      ),
    );
  }

  void _onLoginPressed() async {
    final googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void _onStateChanged(BuildContext context, AuthenticationState state) {
    if (state is UserAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }
}
