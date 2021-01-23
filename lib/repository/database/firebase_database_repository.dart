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
  Future<Iterable<FoodItem>> getFoodItems() async {
    var docs =
        (await FirebaseFirestore.instance.collection(user.uid).get()).docs;

    return docs.map<FoodItem>(
      (x) => FoodItem(
        name: x.get('text').toString(),
      ),
    );
  }
}
