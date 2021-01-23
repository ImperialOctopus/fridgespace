import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

/// Bloc for user sign in.
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  /// Bloc for user sign in.
  AuthenticationBloc() : super(const AuthenticationUninitialised()) {
    /// Listen for changes to sign in state.
    FirebaseAuth.instance.userChanges().listen((event) {
      add(UserChanged(user: event));
    });
  }

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationAppStarted) {
      /// Set state to currently signed in user.
      add(UserChanged(user: FirebaseAuth.instance.currentUser));
    } else if (event is UserChanged) {
      if (event.user == null) {
        yield const UserNotAuthenticated();
      } else {
        yield UserAuthenticated(user: event.user);
      }
    } else {
      throw FallThroughError();
    }
  }
}
