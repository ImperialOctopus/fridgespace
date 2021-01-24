import 'package:flutter/cupertino.dart';

import 'food_item.dart';

/// Model of a bubble of users.
class Offer {
  /// Name of person offering.
  final String offerer;

  /// Name of person offering.
  final String profileImage;

  /// Food item on offer.
  final FoodItem foodItem;

  /// Model of an item of food offered to the bubble.
  const Offer({
    @required this.offerer,
    @required this.profileImage,
    @required this.foodItem,
  });
}
