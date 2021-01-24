import 'dart:async';

import '../../model/bubble.dart';
import '../../model/food_item.dart';
import '../../model/user_profile.dart';
import 'database_repository.dart';

/// Offline fake database for testing.
class MockDatabaseRepository implements DatabaseRepository {
  static const String _memberId = 'ourMemberId';

  final _foodStreamController =
      StreamController<Iterable<FoodItem>>.broadcast();

  Iterable<FoodItem> _mostRecentFood;

  final Map<String, Bubble> _bubbles = const {
    '111111': Bubble(
        memberIds: [_memberId, 'asdaa', 'jjfdhjsahg'], name: 'BubbleOne'),
    '346653753': Bubble(
        memberIds: [_memberId, 'rhahjrt', '101215'], name: 'Second Bubble')
  };

  final _bubbleStreamController = StreamController<Iterable<Bubble>>();

  /// Offline fake database for testing.
  MockDatabaseRepository() {
    _foodStreamController.stream.listen((event) {
      _mostRecentFood = event;
    });
    _foodStreamController.add([
      FoodItem(
        uuid: '0000000000000',
        name: 'Food the first',
        quantity: '2',
        expires: DateTime.now(),
        shared: false,
      ),
      FoodItem(
        uuid: '0000000000001',
        name: 'Food the second',
        quantity: '1',
        expires: DateTime.now(),
        shared: false,
      ),
    ]);
    _bubbleStreamController.add(_bubbles.values);
  }

  @override
  Future<void> addFoodItem(FoodItem foodItem) async {
    _foodStreamController.add([...await getFoodItems(), foodItem]);
  }

  @override
  Stream<Iterable<FoodItem>> get foodlistStream => _foodStreamController.stream;

  @override
  Future<Iterable<FoodItem>> getFoodItems() async {
    return _mostRecentFood;
  }

  @override
  Future<String> createBubble(String name) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _bubbles[id] = Bubble(name: name, memberIds: []);
    _bubbleStreamController.add(_bubbles.values);
    return id;
  }

  @override
  Stream<Iterable<Bubble>> get bubbleStream => _bubbleStreamController.stream;

  @override
  Future<Bubble> getBubble(String id) async {
    return _bubbles[id];
  }

  @override
  Future<Iterable<String>> getBubbleIds() async {
    return _bubbles.entries
        .where((entry) => entry.value.memberIds.contains(_memberId))
        .map<String>((entry) => entry.key);
  }

  @override
  Future<void> joinBubble(String id) async {
    _bubbles.update(
        id,
        (bubble) => Bubble(
            name: bubble.name, memberIds: [...bubble.memberIds, _memberId]));
    _bubbleStreamController.add(_bubbles.values);
  }

  @override
  Future<Iterable<FoodItem>> getFoodItemsFromUser(String id) {
    // TODO: implement getFoodItemsFromUser
    throw UnimplementedError();
  }

  @override
  Future<UserProfile> getUserProfile(String id) {
    // TODO: implement getUserProfile
    throw UnimplementedError();
  }
}
