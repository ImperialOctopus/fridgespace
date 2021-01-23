import 'package:flutter/material.dart';

class FoodItem {
  const FoodItem({
    @required this.name,
    @required this.quantity,
    @required this.expires,
  });

  final String name;
  final String quantity;
  final DateTime expires;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'quantity': quantity,
        'expires': expires,
      };
}
