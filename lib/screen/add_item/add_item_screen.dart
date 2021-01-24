import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/food_item.dart';
import '../../model/product_lookup_result.dart';

/// Screen for adding a new item.
class AddItemScreen extends StatefulWidget {
  /// Result of attempting to lookup this product.
  final ProductLookupResult lookupResult; // Nullable

  /// Screen for adding a new item.
  const AddItemScreen({@required this.lookupResult});

  @override
  State<StatefulWidget> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;
  TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            child: const Text(
              'SAVE',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _submitForm,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: form(),
        ),
      ),
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
                border: InputBorder.none, labelText: 'Item Name'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
                border: InputBorder.none, labelText: 'Item Weight/Count'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a value';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: InputBorder.none, labelText: 'Expiry Date'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a value';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Entering Item')));

      final item = FoodItem(
        name: _nameController.text,
        quantity: _quantityController.text,
        expires: null,
        shared: null,
      );

      print(item.toJson());
    }
  }
}
