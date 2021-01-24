import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/feed/feed_bloc.dart';
import '../../bloc/feed/feed_state.dart';
import '../../model/offer.dart';
import 'package:intl/intl.dart';

/// Page to list items on offer in the user's bubbles.
class FeedPage extends StatelessWidget {
  /// Page to list items on offer in the user's bubbles.
  const FeedPage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        if (state is FeedLoaded) {
          return RefreshIndicator(
              onRefresh: BlocProvider.of<FeedBloc>(context).refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: state.offers
                    .map<Widget>(
                      (Offer x) => ListTile(
                        leading: Image.network(
                          x.offerer.pictureUrl,
                          width: 50,
                        ),
                        title: Text(x.foodItem.name),
                        subtitle: Text('Qty: ' +
                            (x.foodItem.quantity ?? 'unknown') +
                            '\nExpires: ' +
                            (x.foodItem.expires != null
                                ? DateFormat('dd/MM/yy')
                                    .format(x.foodItem.expires)
                                : 'unknown')),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.pink,
                          ),
                          onPressed: () {},
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      ),
                    )
                    .toList(),
              ));
        } else if (state is FeedError) {
          return Center(child: Text('Error: ' + state.message));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
