import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Events for sign in bloc.
abstract class AuthenticationEvent extends Equatable {
  /// Events for sign in bloc.
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

/// App started.
class AuthenticationAppStarted extends AuthenticationEvent {
  /// App started.
  const AuthenticationAppStarted();
}

/// User changed.
class UserChanged extends AuthenticationEvent {
  /// New user object, or null if logged out.
  final User user;

  /// User changed.
  const UserChanged({@required this.user});

  @override
  List<Object> get props => [user];
}
