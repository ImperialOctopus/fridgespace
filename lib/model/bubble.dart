import 'package:flutter/material.dart';

/// Model of a bubble of users.
class Bubble {
  /// 5 letter identifier of bubble.
  final String id;

  /// Name of bubble.
  final String name;

  /// Quantity string, sometimes with unit.
  final Iterable<String> memberIds;

  /// Model of an item of food.
  const Bubble({
    @required this.id,
    @required this.name,
    @required this.memberIds,
  });

  /// Converts this object to a json map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'memberIds': memberIds,
      };
}
