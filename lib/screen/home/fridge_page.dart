import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/foodlist/foodlist_bloc.dart';
import '../../bloc/foodlist/foodlist_state.dart';

/// Page to list items in the user's fridge.
class FridgePage extends StatelessWidget {
  /// Page to list items in the user's fridge.
  const FridgePage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodlistBloc, FoodlistState>(
      builder: (context, state) {
        print(state);

        if (state is FoodlistLoaded) {
          if (state.foodlist.isNotEmpty) {
            return ListView(
                children: state.foodlist
                    .map<Widget>(
                      (x) => ListTile(
                        title: Text(x.name),
                        subtitle: Text('Qty: ' +
                            (x.quantity ?? 'unknown') +
                            '\nExpires: ' +
                            (x.expires != null
                                ? DateFormat('dd/MM/yy').format(x.expires)
                                : 'unknown')),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.share,
                            color: x.shared ? Colors.pink : Colors.grey,
                          ),
                          onPressed: () {},
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      ),
                    )
                    .toList());
          } else {
            return const Center(
              child: Text('Your fridge is empty, wanna go Sains?'),
            );
          }
        } else if (state is FoodlistError) {
          return Center(child: Text('Error: ' + state.message));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
