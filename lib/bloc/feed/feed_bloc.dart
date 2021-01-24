import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/offer_service.dart';
import 'feed_event.dart';
import 'feed_state.dart';

/// Bloc to handle Offers for feed.
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final OfferService _offerService;

  /// Bloc to handle Offers for feed.
  FeedBloc({@required OfferService offerService})
      : _offerService = offerService,
        super(const FeedUnloaded());

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is LoadFeed) {
      yield* _mapLoadToState(event);
    } else if (event is FeedReloaded) {
      yield FeedLoaded(offers: event.newOffers);
    } else {
      throw FallThroughError();
    }
  }

  Stream<FeedState> _mapLoadToState(LoadFeed event) async* {
    yield const FeedLoading();
    final offers = await _offerService.getAllOffersFromConnectedUsers();
    yield FeedLoaded(offers: offers);
  }

  /// Refresh the feed.
  Future<void> refresh() async {
    final offers = await _offerService.getAllOffersFromConnectedUsers();
    add(FeedReloaded(newOffers: offers));
  }
}
