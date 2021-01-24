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
class ReloadFeed extends FeedEvent {
  /// Reload list.
  const ReloadFeed();

  @override
  List<Object> get props => [];
}
