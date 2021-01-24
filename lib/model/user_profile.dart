import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Profile of a user.
class UserProfile extends Equatable {
  /// User's name.
  final String displayName;

  /// Url to user's image.
  final String pictureUrl;

  /// Profile of a user.
  const UserProfile({@required this.displayName, @required this.pictureUrl});

  @override
  List<Object> get props => [displayName, pictureUrl];
}
