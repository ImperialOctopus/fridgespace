import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../exception/join_bubble_exception.dart';
import '../../model/bubble.dart';
import '../../model/food_item.dart';
import '../../model/user_profile.dart';
import 'database_repository.dart';

/// Database implementation using firebase.
class FirebaseDatabaseRepository implements DatabaseRepository {
  /// User to get data from.
  final User user;

  /// Database implementation using firebase.
  FirebaseDatabaseRepository({@required this.user}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((userDoc) {
      if (userDoc.exists) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(<String, String>{
          'imageUrl': user.photoURL,
          'name': user.displayName
        });
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(<String, dynamic>{
          'imageUrl': user.photoURL,
          'name': user.displayName,
          'bubbles': <String>[],
        });
      }
    });
  }

  @override
  Future<void> addFoodItem(FoodItem foodItem) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('fridge')
        .doc(foodItem.uuid)
        .set(foodItem.toJson());
  }

  @override
  Future<Iterable<FoodItem>> getFoodItems() async {
    return getFoodItemsFromUser(user.uid);
  }

  @override
  Stream<Iterable<FoodItem>> get foodlistStream {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('fridge')
        .snapshots()
        .map((QuerySnapshot snapShot) => snapShot.docs)
        .map((documents) {
      return documents.map((doc) {
        final fields = doc.data();
        final date = fields['expires'] as Timestamp;

        return FoodItem(
            uuid: doc.id,
            name: fields['name'].toString(),
            quantity: fields['quantity'].toString(),
            expires: date?.toDate(),
            shared: fields['shared'] as bool);
      });
    });
  }

  @override
  Future<void> setFoodSharing(FoodItem foodItem, bool sharing) async {
    final newFoodItem = FoodItem(
      uuid: foodItem.uuid,
      name: foodItem.name,
      quantity: foodItem.quantity,
      expires: foodItem.expires,
      shared: sharing,
    );
    await addFoodItem(newFoodItem);
  }

  @override
  Future<String> createBubble(String name) async {
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
        .set(Bubble(id: id, name: name, memberIds: [user.uid]).toJson());

    return id;
  }

  @override
  Future<void> joinBubble(String id) async {
    final bubble =
        await FirebaseFirestore.instance.collection('bubbles').doc(id).get();

    if (!bubble.exists) {
      throw const JoinBubbleException('Bubble did not exist');
    }

    // Add user to bubble
    await FirebaseFirestore.instance
        .collection('bubbles')
        .doc(id)
        .update(<String, dynamic>{
      'memberIds': FieldValue.arrayUnion(<dynamic>[user.uid])
    });

    final userRecord = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    // Add bubble to user
    if (userRecord.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(<String, dynamic>{
        'bubbles': FieldValue.arrayUnion(<dynamic>[id])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(<String, dynamic>{
        'bubbles': FieldValue.arrayUnion(<dynamic>[id])
      });
    }
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
        id: id,
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
  Future<void> leaveBubble(String id) async {
    final bubble =
        await FirebaseFirestore.instance.collection('bubbles').doc(id).get();

    if (!bubble.exists) {
      throw const JoinBubbleException('Bubble did not exist');
    }

    // Remove user from bubble
    await FirebaseFirestore.instance
        .collection('bubbles')
        .doc(id)
        .update(<String, dynamic>{
      'memberIds': FieldValue.arrayRemove(<dynamic>[user.uid])
    });

    final userRecord = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    // Remove bubble from user
    if (userRecord.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(<String, dynamic>{
        'bubbles': FieldValue.arrayRemove(<dynamic>[id])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(<String, dynamic>{
        'bubbles': FieldValue.arrayRemove(<dynamic>[id])
      });
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

  @override
  Future<Iterable<FoodItem>> getFoodItemsFromUser(String id) async {
    final fridge = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('fridge')
        .get();

    return fridge.docs.map<FoodItem>((doc) {
      final fields = doc.data();
      final date = fields['expires'] as Timestamp;

      return FoodItem(
          uuid: doc.id,
          name: fields['name'].toString(),
          quantity: fields['quantity'].toString(),
          expires: date?.toDate(),
          shared: fields['shared'] as bool);
    });
  }

  @override
  Future<UserProfile> getUserProfile(String id) async {
    var user =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    return UserProfile(
      displayName: user.get('name').toString(),
      pictureUrl: user.get('imageUrl').toString(),
    );
  }

  String _getRandomString(int length) {
    var r = Random();
    final chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(length, (index) => chars[r.nextInt(chars.length)])
        .join();
  }
}
