import 'package:flutter_bloc/flutter_bloc.dart';

import 'foodlist_event.dart';
import 'foodlist_state.dart';

/// Bloc for user's food list.
class FoodlistBloc extends Bloc<FoodlistEvent, FoodlistState> {
  /// Bloc for user's food list.
  FoodlistBloc() : super(FoodlistUnloaded());

  @override
  Stream<FoodlistState> mapEventToState(FoodlistEvent event) async* {
    if (event is LoadFoodlist) {
      yield* _mapLoadToState(event);
    }
    if (event is AddFoodItem) {
      //yield* _mapAddToState(event);
    }
  }

  Stream<FoodlistState> _mapLoadToState(LoadFoodlist event) async* {
    yield const FoodlistLoaded(foodlist: []);
  }
}
