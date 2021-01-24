import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/bubble_join_service.dart';
import '../../bloc/bubble/bubble_bloc.dart';
import '../../bloc/bubble/bubble_state.dart';
import '../join_bubble/create_bubble_screen.dart';

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
              itemCount: list.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < list.length) {
                  return Container(
                    height: 150,
                    child: Card(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                      'Bubble: ${list.elementAt(index).name}')),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 4.0),
                                  child: RaisedButton(
                                      onPressed: () => RepositoryProvider.of<
                                          BubbleJoinService>(context)
                                          .leaveBubble(list.elementAt(index).id),
                                      child: const Text('Leave Bubble')))
                            ])),
                  );
                } else {
                  return TextButton(
                      onPressed: () => _openCreateBubblesPage(context),
                      child: const Text('Create Bubble'));
                }
              },
              separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
            ),
          );
        } else {
          return Column(children: <Widget>[
            const Text("You aren't part of any bubbles yet"),
            TextButton(
                onPressed: () => _openCreateBubblesPage(context),
                child: const Text('Create Bubble'))
          ]);
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

  void _openCreateBubblesPage(BuildContext context) {
    Navigator.of(context).push<void>(MaterialPageRoute<void>(
        builder: (context) => const CreateBubbleScreen()));
  }
}