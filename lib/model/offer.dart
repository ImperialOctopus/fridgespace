import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'food_item.dart';
import 'user_profile.dart';

/// Model of a bubble of users.
class Offer extends Equatable {
  /// Name of person offering.
  final UserProfile offerer;

  /// Food item on offer.
  final FoodItem foodItem;

  /// Model of an item of food offered to the bubble.
  const Offer({
    @required this.offerer,
    @required this.foodItem,
  });

  @override
  List<Object> get props => [offerer, foodItem];
}
