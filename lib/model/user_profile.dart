import 'package:flutter/material.dart';

/// Profile of a user.
class UserProfile {
  /// User's name.
  final String displayName;

  /// Url to user's image.
  final String pictureUrl;

  /// Profile of a user.
  const UserProfile({@required this.displayName, @required this.pictureUrl});
}
