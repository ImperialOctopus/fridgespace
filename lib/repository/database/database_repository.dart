import '../../model/bubble.dart';
import '../../model/food_item.dart';
import '../../model/user_profile.dart';

/// Repository for database.
abstract class DatabaseRepository {
  /// Adds a food item to a user's fridge.
  Future<void> addFoodItem(FoodItem foodItem);

  /// Fetch list of user's food items.
  Future<Iterable<FoodItem>> getFoodItems();

  /// Stream of food lists.
  Stream<Iterable<FoodItem>> get foodlistStream;

  /// Set sharing for a single food item.
  Future<void> setFoodSharing(String foodId, bool sharing);

  /// Creates a new bubble and returns its ID.
  Future<String> createBubble(String name);

  /// Adds a bubble to a user's bubbles, and the user to that bubble.
  Future<void> joinBubble(String bubble);

  /// Fetch list of user's bubbles.
  Future<Iterable<String>> getBubbleIds();

  /// Stream of user's bubbles.
  Stream<Iterable<Bubble>> get bubbleStream;

  /// Fetch a bubble by ID
  Future<Bubble> getBubble(String id);

  /// Leave a bubble by ID
  Future<void> leaveBubble(String id);

  /// Gets all food items owned by a user.
  Future<Iterable<FoodItem>> getFoodItemsFromUser(String id);

  /// Get a user's profile by id
  Future<UserProfile> getUserProfile(String id);
}
