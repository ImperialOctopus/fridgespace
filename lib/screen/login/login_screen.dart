import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_state.dart';
import '../../service/login/google_login_service.dart';
import '../loading/loading_page.dart';

/// Screen to show when app loads, before sign in.
class LoginScreen extends StatelessWidget {
  /// Screen to show when app loads, before sign in.
  const LoginScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is UserNotAuthenticated) {
            return Center(
              child: RaisedButton(
                onPressed: RepositoryProvider.of<GoogleLoginService>(context)
                    .openLogin,
                child: const Text('Log In'),
              ),
            );
          }
          return const LoadingPage();
        },
      ),
    );
  }
}
