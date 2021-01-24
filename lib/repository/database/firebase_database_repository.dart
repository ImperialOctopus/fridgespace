import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/bubble.dart';
import '../../model/food_item.dart';

import 'database_repository.dart';

/// Database implementation using firebase.
class FirebaseDatabaseRepository implements DatabaseRepository {
  /// User to get data from.
  final User user;

  /// Database implementation using firebase.
  FirebaseDatabaseRepository({@required this.user});

  @override
  Future<void> addFoodItem(FoodItem foodItem) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update(<String, dynamic>{
      'fridge': FieldValue.arrayUnion(<dynamic>[foodItem.toJson()])
    });
  }

  @override
  Future<Iterable<FoodItem>> getFoodItems() async {
    return (await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get())['fridge'] as List<FoodItem>;
  }

  @override
  Future<String> addBubble(Bubble bubble) async {
    String id;
    DocumentReference docRef;

    do {
      id = _getRandomString(5);
      docRef = await FirebaseFirestore.instance.collection('bubbles').doc(id);
    } while ((await docRef.get()).exists);

    await FirebaseFirestore.instance
        .collection('bubbles')
        .doc(id)
        .update(bubble.toJson());

    return id;
  }

  @override
  Future<void> joinBubble(String id) async {
    // Add bubble to user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update(<String, dynamic>{
      'bubbles': FieldValue.arrayUnion(<dynamic>[id])
    });

    // Add user to bubble
    await FirebaseFirestore.instance
        .collection('bubbles')
        .doc(id)
        .update(<String, dynamic>{
      'members': FieldValue.arrayUnion(<dynamic>[user.uid])
    });
  }

  @override
  Future<Iterable<Bubble>> getBubbles() async {
    return (await FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .get())['bubbles'] as List<Bubble>;
  }

  String _getRandomString(int length) {
    var r = Random();
    final chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(length, (index) => chars[r.nextInt(chars.length)])
        .join();
  }
}
