import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Model of an item of food.
class FoodItem extends Equatable {
  /// Unique identifier.
  final String uuid;

  /// Name of food.
  final String name;

  /// Quantity string, sometimes with unit.
  final String quantity;

  /// Best before or use by date.
  final DateTime expires;

  /// Whether this item is okay for others to take.
  final bool shared;

  /// Model of an item of food.
  const FoodItem({
    @required this.uuid,
    @required this.name,
    @required this.quantity,
    @required this.expires,
    @required this.shared,
  });

  /// Converts this object to a json map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'quantity': quantity,
        'expires': expires,
        'shared': shared,
      };

  @override
  List<Object> get props => [uuid, name, quantity, expires, shared];
}
