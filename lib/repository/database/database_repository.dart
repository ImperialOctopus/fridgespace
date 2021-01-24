import '../../model/food_item.dart';
import '../../model/bubble.dart';

/// Repository for database.
abstract class DatabaseRepository {
  /// Adds a food item to a user's fridge.
  Future<void> addFoodItem(FoodItem foodItem);

  /// Fetch list of user's food items.
  Future<Iterable<FoodItem>> getFoodItems();

  /// Creates a new bubble and returns its ID.
  Future<String> addBubble(Bubble bubble);

  /// Adds a bubble to a user's bubbles, and the user to that bubble.
  Future<void> joinBubble(String bubble);

  /// Fetch list of user's bubbles.
  Future<Iterable<Bubble>> getBubbles();
}
