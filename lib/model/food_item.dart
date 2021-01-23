import 'package:flutter/material.dart';

class FoodItem {
  const FoodItem({
    @required this.name,
    @required this.quantity,
  });

  final String name;
  final String quantity;
}
