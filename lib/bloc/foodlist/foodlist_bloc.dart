import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/database/database_repository.dart';
import 'foodlist_event.dart';
import 'foodlist_state.dart';

/// Bloc for user's food list.
class FoodlistBloc extends Bloc<FoodlistEvent, FoodlistState> {
  final DatabaseRepository _databaseRepository;

  /// Bloc for user's food list.
  FoodlistBloc({@required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(FoodlistUnloaded()) {
    _databaseRepository.foodlistStream
        .listen((foodlist) => add(FoodlistChanged(foodlist: foodlist)));
  }

  @override
  Stream<FoodlistState> mapEventToState(FoodlistEvent event) async* {
    if (event is LoadFoodlist) {
      yield* _mapLoadToState(event);
    }
    if (event is AddFoodItem) {
      yield* _mapAddToState(event);
    }
  }

  Stream<FoodlistState> _mapLoadToState(LoadFoodlist event) async* {
    yield const FoodlistLoading();
    try {
      final foodList = await _databaseRepository.getFoodItems();
      yield FoodlistLoaded(foodlist: foodList);
    } catch (e) {
      yield FoodlistError(e.toString());
    }
  }

  Stream<FoodlistState> _mapAddToState(AddFoodItem event) async* {
    await _databaseRepository.addFoodItem(event.foodItem);
  }
}
