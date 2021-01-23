import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../model/food_item.dart';

/// List of foods in user's fridge.
abstract class FoodlistState extends Equatable {
  /// List of foods in user's fridge.
  const FoodlistState();

  @override
  List<Object> get props => [];
}

class FoodlistUnloaded extends FoodlistState {}

/// Food list is loading.
class FoodlistLoading extends FoodlistState {
  /// Food list is loading.
  const FoodlistLoading();
}

/// Food list loaded.
class FoodlistLoaded extends FoodlistState {
  /// List of food items.
  final Iterable<FoodItem> foodlist;

  /// Food list loaded.
  const FoodlistLoaded({@required this.foodlist});
}

/// Error occurred fetching food list.
class FoodlistError extends FoodlistState {
  /// Error message to display.
  final String message;

  /// Error occurred fetching food list.
  const FoodlistError([this.message = '']);

  @override
  List<Object> get props => [message];
}
