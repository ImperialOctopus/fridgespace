import 'package:foodcoin/model/food_item.dart';

/// Repository for database.
abstract class DatabaseRepository {
  Future<Iterable<FoodItem>> getFoodItems();
}
