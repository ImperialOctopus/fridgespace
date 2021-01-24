import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bubble/bubble_bloc.dart';
import '../../bloc/bubble/bubble_state.dart';

/// Page to display user's bubbles.
class BubblesPage extends StatelessWidget {
  const BubblesPage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BubbleBloc, BubbleState>(builder: (context, state) {
      if (state is BubblesLoaded) {
        final list = state.bubbles;

        return Scaffold(
          body: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                child: Card(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Entry ${list.elementAt(index)}')),
                      const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 4.0),
                          child: RaisedButton(
                              onPressed: null, child: Text('Press Me')))
                    ])),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
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
