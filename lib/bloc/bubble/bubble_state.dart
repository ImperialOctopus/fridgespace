import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../model/bubble.dart';

/// State for bubble list bloc.
abstract class BubbleState extends Equatable {
  /// State for bubble list bloc.
  const BubbleState();

  @override
  List<Object> get props => [];
}

/// Bubbles not loaded.
class BubblesUnloaded extends BubbleState {
  /// Bubbles not loaded.
  const BubblesUnloaded();
}

/// Bubbles being loaded.
class BubblesLoading extends BubbleState {
  /// Bubbles being loaded.
  const BubblesLoading();
}

/// Bubble list loaded.
class BubblesLoaded extends BubbleState {
  /// Bubble list loaded.
  final Iterable<Bubble> bubbles;

  /// Bubble list loaded.
  const BubblesLoaded({@required this.bubbles});
}
