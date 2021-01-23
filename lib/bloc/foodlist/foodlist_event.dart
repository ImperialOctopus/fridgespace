import 'package:equatable/equatable.dart';

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
class AddFoodItem extends FoodlistEvent {}
