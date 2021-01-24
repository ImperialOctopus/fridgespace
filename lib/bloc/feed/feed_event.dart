import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../model/offer.dart';

/// Event for feed list bloc.
abstract class FeedEvent extends Equatable {
  /// Event for feed list bloc.
  const FeedEvent();
}

/// Load feed list.
class LoadFeed extends FeedEvent {
  /// Load feed list.
  const LoadFeed();

  @override
  List<Object> get props => [];
}

/// Reload list.
class FeedReloaded extends FeedEvent {
  /// New offers.
  final Iterable<Offer> newOffers;

  /// Reload list.
  const FeedReloaded({@required this.newOffers});

  @override
  List<Object> get props => [newOffers];
}
