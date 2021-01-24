import 'package:fridgespace/model/user_profile.dart';

import '../../model/food_item.dart';
import '../../model/bubble.dart';

/// Repository for database.
abstract class DatabaseRepository {
  /// Adds a food item to a user's fridge.
  Future<void> addFoodItem(FoodItem foodItem);

  /// Fetch list of user's food items.
  Future<Iterable<FoodItem>> getFoodItems();

  /// Stream of food lists.
  Stream<Iterable<FoodItem>> get foodlistStream;

  /// Creates a new bubble and returns its ID.
  Future<String> addBubble(Bubble bubble);

  /// Adds a bubble to a user's bubbles, and the user to that bubble.
  Future<void> joinBubble(String bubble);

  /// Fetch list of user's bubbles.
  Future<Iterable<String>> getBubbleIds();

  /// Stream of user's bubbles.
  Stream<Iterable<Bubble>> get bubbleStream;

  /// Fetch a bubble by ID
  Future<Bubble> getBubble(String id);

  /// Gets all food items owned by a user.
  Future<Iterable<FoodItem>> getFoodItemsFromUser(String id);

  /// Get a user's profile by id
  Future<UserProfile> getUserProfile(String id);
}
