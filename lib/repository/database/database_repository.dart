import '../../model/food_item.dart';

/// Repository for database.
abstract class DatabaseRepository {
  Future<void> pushFoodItem(FoodItem foodItem);
  Future<Iterable<FoodItem>> getFoodItems();
}
