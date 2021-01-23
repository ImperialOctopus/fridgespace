import 'package:equatable/equatable.dart';

abstract class FoodlistEvent extends Equatable {
  const FoodlistEvent();

  @override
  List<Object> get props => [];
}

class LoadFoodlist extends FoodlistEvent {
  const LoadFoodlist();
}

class AddFoodItem extends FoodlistEvent {}
