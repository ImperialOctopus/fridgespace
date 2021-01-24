import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../model/offer.dart';

/// State for feed list bloc.
abstract class FeedState extends Equatable {
  /// State for feed list bloc.
  const FeedState();
}

/// Feed not loaded.
class FeedUnloaded extends FeedState {
  /// Feed not loaded.
  const FeedUnloaded();

  @override
  List<Object> get props => [];
}

/// Feed being loaded.
class FeedLoading extends FeedState {
  /// Feed being loaded.
  const FeedLoading();

  @override
  List<Object> get props => [];
}

/// Offer list loaded.
class FeedLoaded extends FeedState {
  /// Offer list loaded.
  final Iterable<Offer> offers;

  /// Bubble list loaded.
  const FeedLoaded({@required this.offers});

  @override
  List<Object> get props => [offers];
}

/// Error occurred fetching feed list.
class FeedError extends FeedState {
  /// Error message to display.
  final String message;

  /// Error occurred fetching feed list.
  const FeedError([this.message = '']);

  @override
  List<Object> get props => [message];
}
