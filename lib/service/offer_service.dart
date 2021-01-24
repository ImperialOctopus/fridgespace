import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fridgespace/model/bubble.dart';
import 'package:fridgespace/model/food_item.dart';
import 'package:fridgespace/model/offer.dart';

import '../repository/database/database_repository.dart';

/// Service to get offers from database.
class OfferService {
  /// Signed in user.
  final User user;

  /// Database repository.
  final DatabaseRepository databaseRepository;

  /// Service to get offers from database.
  const OfferService({@required this.databaseRepository});

  /// Get IDs of connected users.
  Future<Set<String>> connectedUsers() async {
    final myBubbleIds = await databaseRepository.getBubbleIds();

    // Get all IDs for connected users.
    final iterables = await Future.wait(
        myBubbleIds.map<Future<Iterable<String>>>((bubbleId) async {
      final bubble = await databaseRepository.getBubble(bubbleId);
      return bubble.memberIds;
    }));

    // Expand IDs into a set.
    iterables.expand((element) => element).toSet();
  }

  /// Get all food shared by a user.
  Future<Iterable<FoodItem>> getSharedFood(String id) async {
    return (await databaseRepository.getFoodItemsFromUser(id))
        .where((foodItem) => foodItem.shared);
  }

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

  Future<Iterable<Offer>> getAllOffers(Set<String> ids) async {
    (await Future.wait<Iterable<Offer>>(
      ids.map(
        (id) => getUsersOffers(id),
      ),
    ))
        .expand<Offer>((element) => element);
  }
}
