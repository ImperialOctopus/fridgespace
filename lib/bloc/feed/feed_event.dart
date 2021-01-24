import 'package:equatable/equatable.dart';

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
class ReloadBubbles extends FeedEvent {
  /// Reload list.
  const ReloadBubbles();

  @override
  List<Object> get props => [];
}
