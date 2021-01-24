import 'package:flutter/material.dart';

import '../../model/product_lookup_result.dart';

/// Screen for adding a new item.
class AddItemScreen extends StatelessWidget {
  /// Result of attempting to lookup this product.
  final ProductLookupResult lookupResult;

  /// Screen for adding a new item.
  const AddItemScreen({@required this.lookupResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            child: const Text('SAVE'),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Add Item Screen'),
              Text(lookupResult.toString()),
              Text(lookupResult?.name ?? 'name missing'),
              Text(lookupResult?.quantity ?? 'quantity missing'),
            ],
          ),
        ),
      ),
    );
  }
}
