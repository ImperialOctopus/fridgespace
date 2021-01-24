import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/database/database_repository.dart';
import '../../model/food_item.dart';

/// Page to list items in the user's fridge.
class FridgePage extends StatelessWidget {
  /// Page to list items in the user's fridge.
  const FridgePage();

  @override
  Widget build(BuildContext context) {
    // RepositoryProvider.of<DatabaseRepository>(context).addFoodItem(FoodItem(
    //   name: "Cheese",
    //   quantity: "",
    //   expires: DateTime(2020),
    //   shared: false,
    // ));

    return FutureBuilder<Iterable<FoodItem>>(
      future: RepositoryProvider.of<DatabaseRepository>(context).getFoodItems(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
              children: snapshot.data
                  .map<Widget>(
                    (x) => ListTile(
                      title: Text(x.name),
                      subtitle: Text('Qty: ' +
                          (x.quantity ?? 'unknown') +
                          ' Expires: ' +
                          (x.expires.toString() ?? 'unknown')),
                    ),
                  )
                  .toList());
        } else if (snapshot.hasError) {
          print('Error: ' + snapshot.error.toString());
          return Center(child: Text('Error: ' + snapshot.error.toString()));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
