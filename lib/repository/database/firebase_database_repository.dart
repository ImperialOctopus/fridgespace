import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/food_item.dart';

import 'database_repository.dart';

/// Database implementation using firebase.
class FirebaseDatabaseRepository implements DatabaseRepository {
  final User user;

  FirebaseDatabaseRepository({@required this.user});

  @override
  Future<void> pushFoodItem(FoodItem foodItem) async {
    await FirebaseFirestore.instance
        .collection(user.uid)
        .add(jsonDecode(jsonEncode(foodItem)) as Map<String, dynamic>);
  }

  @override
  Future<Iterable<FoodItem>> getFoodItems() async {
    var docs =
        (await FirebaseFirestore.instance.collection(user.uid).get()).docs;

    return docs.map<FoodItem>(
      (x) => FoodItem(
          name: x.get('name') as String,
          quantity: x.get('quantity') as String,
          expires: x.get('expires') as DateTime),
    );
  }
}
