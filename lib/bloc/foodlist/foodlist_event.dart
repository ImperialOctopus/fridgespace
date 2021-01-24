import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../model/food_item.dart';

/// Event for foodlist bloc.
abstract class FoodlistEvent extends Equatable {
  /// Event for foodlist bloc.
  const FoodlistEvent();

  @override
  List<Object> get props => [];
}

/// Load food list.
class LoadFoodlist extends FoodlistEvent {
  /// Load food list.
  const LoadFoodlist();
}

/// Add a food item to list.
class AddFoodItem extends FoodlistEvent {
  /// Food item to add.
  final FoodItem foodItem;

  /// Add a food item to list.
  const AddFoodItem({@required this.foodItem});

  @override
  List<Object> get props => [foodItem];
}

/// Food list was changed by the server.
class FoodlistChanged extends FoodlistEvent {
  /// New list of food.
  final Iterable<FoodItem> foodlist;

  /// Food list was changed by the server.
  const FoodlistChanged({@required this.foodlist});

  @override
  List<Object> get props => [foodlist];
}
