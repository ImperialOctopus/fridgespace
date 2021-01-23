import 'package:flutter/material.dart';

/// Model of an item of food.
class FoodItem {
  /// Name of food.
  final String name;

  /// Quantity string, sometimes with unit.
  final String quantity;

  /// Best before or use by date.
  final DateTime expires;

  /// Model of an item of food.
  const FoodItem({
    @required this.name,
    @required this.quantity,
    @required this.expires,
  });

  /// Converts this object to a json map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'quantity': quantity,
        'expires': expires,
      };
}
