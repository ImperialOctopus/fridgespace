import 'package:flutter/material.dart';

import '../model/bubble.dart';
import '../repository/database/database_repository.dart';

/// Service to join or leave bubbles.
class BubbleJoinService {
  final DatabaseRepository _databaseRepository;

  /// Service to join or leave bubbles.
  const BubbleJoinService({@required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository;

  /// Join a bubble by code.
  Future<void> joinBubble(String code) => _databaseRepository.joinBubble(code);

  /// Create bubble
  Future<void> createBubble(Bubble bubble) =>
      _databaseRepository.createBubble(bubble);

  /// Leave a bubble.
  Future<void> leaveBubble(Bubble bubble) {
    // TODO: implement leave bubble
    throw UnimplementedError();
  }
}
