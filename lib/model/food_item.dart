import 'package:flutter/material.dart';

/// Model of an item of food.
class FoodItem {
  /// Name of food.
  final String name;

  /// Quantity string, sometimes with unit.
  final String quantity;

  /// Model of an item of food.
  const FoodItem({
    @required this.name,
    @required this.quantity,
  });

  /// Converts this object to a json map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'quantity': quantity,
      };
}
