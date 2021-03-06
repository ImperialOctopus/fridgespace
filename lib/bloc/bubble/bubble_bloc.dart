import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/database/database_repository.dart';
import 'bubble_event.dart';
import 'bubble_state.dart';

/// Bloc for handling bubble list.
class BubbleBloc extends Bloc<BubbleEvent, BubbleState> {
  final DatabaseRepository _databaseRepository;

  /// Bloc for handling bubble list.
  BubbleBloc({@required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(const BubblesUnloaded()) {
    _databaseRepository.bubbleStream
        .listen((bubbles) => add(BubblesChanged(bubbles: bubbles)));
  }

  @override
  Stream<BubbleState> mapEventToState(BubbleEvent event) async* {
    if (event is LoadBubbles) {
      yield* _mapLoadToState(event);
    } else if (event is BubblesChanged) {
      yield* _mapChangedToState(event);
    } else {
      throw FallThroughError();
    }
  }

  Stream<BubbleState> _mapLoadToState(LoadBubbles event) async* {
    yield const BubblesLoading();
    try {
      final bubbleIds = await _databaseRepository.getBubbleIds();
      final bubbles = await Future.wait(
          bubbleIds.map((id) => _databaseRepository.getBubble(id)));
      yield BubblesLoaded(bubbles: bubbles);
    } catch (e) {
      yield BubbleError(e.toString());
    }
  }

  Stream<BubbleState> _mapChangedToState(BubblesChanged event) async* {
    yield BubblesLoaded(bubbles: event.bubbles);
  }
}
