import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/database/database_repository.dart';
import 'feed_event.dart';
import 'feed_state.dart';

/// Bloc to handle Offers for feed.
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final DatabaseRepository _databaseRepository;

  /// Bloc to handle Offers for feed.
  FeedBloc({@required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(const FeedUnloaded());

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is LoadFeed) {
      yield* _mapLoadToState(event);
    } else {
      throw FallThroughError();
    }
  }

  Stream<FeedState> _mapLoadToState(LoadFeed event) async* {
    yield const FeedLoading();

    yield FeedLoaded();
  }
}
