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
    final userRecord = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userRecord.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(<String, dynamic>{
        'fridge': FieldValue.arrayUnion(<dynamic>[foodItem.toJson()])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(<String, dynamic>{
        'fridge': FieldValue.arrayUnion(<dynamic>[foodItem.toJson()])
      });
    }
  }

  @override
  Future<Iterable<FoodItem>> getFoodItems() async {
    final userRecord = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userRecord.exists) {
      final docs = userRecord.get('fridge') as List<dynamic>;

      return docs.map<FoodItem>((dynamic e) {
        final fields = e as Map<String, dynamic>;
        final date = fields['expires'] as Timestamp;

        return FoodItem(
            name: fields['name'].toString(),
            quantity: fields['quantity'].toString(),
            expires: date.toDate(),
            shared: fields['shared'] as bool);
      });
    } else {
      return [];
    }
  }

  @override
  Stream<Iterable<FoodItem>> get foodlistStream {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((userRecord) {
      if (userRecord.exists) {
        var docs = userRecord.get('fridge') as List<dynamic>;

        return docs.map<FoodItem>((dynamic e) {
          var fields = e as Map<String, dynamic>;
          var date = fields['expires'] as Timestamp;

          return FoodItem(
              name: fields['name'].toString(),
              quantity: fields['quantity'].toString(),
              expires: date.toDate(),
              shared: fields['shared'] as bool);
        });
      } else {
        return <FoodItem>[];
      }
    });
  }

  @override
  Future<String> addBubble(Bubble bubble) async {
    String id;
    DocumentReference docRef;
    DocumentSnapshot doc;

    do {
      id = _getRandomString(5);
      docRef = FirebaseFirestore.instance.collection('bubbles').doc(id);
      doc = await docRef.get();
    } while (doc.exists);

    await FirebaseFirestore.instance
        .collection('bubbles')
        .doc(id)
        .set(bubble.toJson());

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
  Future<Iterable<String>> getBubbleIds() async {
    final userRecord = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userRecord.exists) {
      final docs = userRecord.get('bubbles') as List<dynamic>;

      return docs.map<String>((dynamic e) {
        return e as String;
      });
    } else {
      return [];
    }
  }

  @override
  Future<Bubble> getBubble(String id) async {
    final bubble =
        await FirebaseFirestore.instance.collection('bubbles').doc(id).get();

    if (bubble.exists) {
      final memberIds = bubble['memberIds'] as List<dynamic>;

      return Bubble(
        name: bubble['name'].toString(),
        memberIds: memberIds.map<String>((dynamic e) {
          return e as String;
        }),
      );
    } else {
      return null;
    }
  }

  @override
  Stream<Iterable<Bubble>> get bubbleStream {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .asyncMap((userRecord) async {
      if (userRecord.exists) {
        var bubbleIds = userRecord.get('bubbles') as List<String>;

        return Future.wait(bubbleIds.map<Future<Bubble>>((String id) {
          return getBubble(id);
        }));
      } else {
        return <Bubble>[];
      }
    });
  }

  String _getRandomString(int length) {
    var r = Random();
    final chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(length, (index) => chars[r.nextInt(chars.length)])
        .join();
  }
}
