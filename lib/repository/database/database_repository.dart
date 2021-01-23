import '../../model/food_item.dart';

/// Repository for database.
abstract class DatabaseRepository {
  /// Adds a food item to a user's list.
  Future<void> pushFoodItem(FoodItem foodItem);

  /// Fetch list of user's food items.
  Future<Iterable<FoodItem>> getFoodItems();
}
