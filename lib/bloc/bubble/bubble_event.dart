import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../model/bubble.dart';

/// Event for bubble list bloc.
abstract class BubbleEvent extends Equatable {
  /// Event for bubble list bloc.
  const BubbleEvent();
}

/// Load bubble list.
class LoadBubbles extends BubbleEvent {
  /// Load bubble list.
  const LoadBubbles();

  @override
  List<Object> get props => [];
}

/// Food list was changed by the server.
class BubblesChanged extends BubbleEvent {
  /// New list of food.
  final Iterable<Bubble> bubbles;

  /// Food list was changed by the server.
  const BubblesChanged({@required this.bubbles});

  @override
  List<Object> get props => [bubbles];
}

/// Join a bubble by join code.
class JoinBubble extends BubbleEvent {
  /// Code for bubble to join.
  final String code;

  /// Join a bubble by join code.
  const JoinBubble({@required this.code});

  @override
  List<Object> get props => [code];
}

/// Leave a bubble.
class LeaveBubble extends BubbleEvent {
  /// Bubble to leave.
  final Bubble bubble;

  /// Leave a bubble.
  const LeaveBubble({@required this.bubble});

  @override
  List<Object> get props => [bubble];
}
