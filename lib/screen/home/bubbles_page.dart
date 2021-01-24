import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bubble/bubble_bloc.dart';
import '../../bloc/bubble/bubble_state.dart';

/// Page to display user's bubbles.
class BubblesPage extends StatelessWidget {
  /// Page to display user's bubbles.
  const BubblesPage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BubbleBloc, BubbleState>(builder: (context, state) {
      if (state is BubblesLoaded) {
        final list = state.bubbles;

        if (list.isNotEmpty) {
          return Scaffold(
            body: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 150,
                  child: Card(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child:
                                Text('Bubble: ${list.elementAt(index).name}')),
                        const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 4.0),
                            child: RaisedButton(
                                onPressed: null, child: Text('Leave Bubble')))
                      ])),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          );
        } else {
          return const Center(
              child: Text("You aren't part of any bubbles yet"));
        }
      } else if (state is BubbleError) {
        return const Center(
          child: Text('Error fetching your bubbles.'),
        );
      } else {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
