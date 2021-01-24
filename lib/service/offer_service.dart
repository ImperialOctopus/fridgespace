import 'package:flutter/material.dart';

import '../model/food_item.dart';
import '../model/offer.dart';
import '../repository/database/database_repository.dart';

/// Service to get offers from database.
class OfferService {
  /// Database repository.
  final DatabaseRepository databaseRepository;

  /// Service to get offers from database.
  const OfferService({@required this.databaseRepository});

  /// Get IDs of connected users.
  Future<Set<String>> getConnectedUsers() async {
    final myBubbleIds = await databaseRepository.getBubbleIds();

    // Get all IDs for connected users.
    final iterables = await Future.wait(
        myBubbleIds.map<Future<Iterable<String>>>((bubbleId) async {
      final bubble = await databaseRepository.getBubble(bubbleId);
      return bubble.memberIds;
    }));

    // Expand IDs into a set.
    return iterables.expand((element) => element).toSet();
  }

  /// Get all food shared by a user.
  Future<Iterable<FoodItem>> getSharedFood(String id) async {
    return (await databaseRepository.getFoodItemsFromUser(id))
        .where((foodItem) => foodItem.shared);
  }

  /// Get offers from a single user.
  Future<Iterable<Offer>> getUsersOffers(String id) async {
    final sharedFood = await getSharedFood(id);

    if (sharedFood.isEmpty) {
      return [];
    } else {
      final userProfile = await databaseRepository.getUserProfile(id);

      return sharedFood.map(
        (foodItem) => Offer(
          foodItem: foodItem,
          offerer: userProfile,
        ),
      );
    }
  }

  /// Get all available offers from a list of user ids.
  Future<Iterable<Offer>> getAllOffersFromUsers(Set<String> ids) async {
    return (await Future.wait<Iterable<Offer>>(
      ids.map((id) => getUsersOffers(id)),
    ))
        .expand<Offer>((element) => element);
  }

  /// Get all offers from all connected users.
  Future<Iterable<Offer>> getAllOffersFromConnectedUsers() async {
    final users = await getConnectedUsers();
    return getAllOffersFromUsers(users);
  }
}
