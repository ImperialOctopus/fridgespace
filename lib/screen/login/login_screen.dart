import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Screen to show when app loads, before sign in.
class LoginScreen extends StatelessWidget {
  /// Screen to show when app loads, before sign in.
  const LoginScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: RaisedButton(
        onPressed: _onLoginPressed,
        child: const Text('Log In'),
      ),
    ));
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
    final cred = await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
