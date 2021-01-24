import 'package:flutter_bloc/flutter_bloc.dart';

import 'bubble_event.dart';
import 'bubble_state.dart';

///
class BubbleBloc extends Bloc<BubbleEvent, BubbleState> {
  BubbleBloc() : super(const BubblesUnloaded());

  @override
  Stream<BubbleState> mapEventToState(BubbleEvent event) {
    throw UnimplementedError();
  }
}
