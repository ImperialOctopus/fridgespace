import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// State of sign in bloc.
abstract class AuthenticationState extends Equatable {
  /// Sign in bloc uninitialised.
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

/// Sign in bloc uninitialised.
class AuthenticationUninitialised extends AuthenticationState {
  /// Sign in bloc uninitialised.
  const AuthenticationUninitialised();
}

/// Signed in.
class UserAuthenticated extends AuthenticationState {
  /// Authorisation credential.
  final User user;

  /// Signed in.
  const UserAuthenticated({@required this.user});

  @override
  List<Object> get props => [user];
}

/// Signed out.
class UserNotAuthenticated extends AuthenticationState {
  /// Signed out.
  const UserNotAuthenticated();
}
