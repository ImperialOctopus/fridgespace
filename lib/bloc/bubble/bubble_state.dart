import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../model/bubble.dart';

/// State for bubble list bloc.
abstract class BubbleState extends Equatable {
  /// State for bubble list bloc.
  const BubbleState();
}

/// Bubbles not loaded.
class BubblesUnloaded extends BubbleState {
  /// Bubbles not loaded.
  const BubblesUnloaded();

  @override
  List<Object> get props => [];
}

/// Bubbles being loaded.
class BubblesLoading extends BubbleState {
  /// Bubbles being loaded.
  const BubblesLoading();

  @override
  List<Object> get props => [];
}

/// Bubble list loaded.
class BubblesLoaded extends BubbleState {
  /// Bubble list loaded.
  final Iterable<Bubble> bubbles;

  /// Bubble list loaded.
  const BubblesLoaded({@required this.bubbles});

  @override
  List<Object> get props => [bubbles];
}

/// Error occurred fetching bubble list.
class BubbleError extends BubbleState {
  /// Error message to display.
  final String message;

  /// Error occurred fetching bubble list.
  const BubbleError([this.message = '']);

  @override
  List<Object> get props => [message];
}
