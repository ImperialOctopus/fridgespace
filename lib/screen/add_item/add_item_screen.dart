import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../../model/product_lookup_result.dart';

class ItemForm extends StatefulWidget {
  @override
  ItemFormState createState() {
    return ItemFormState();
  }
}

class ItemFormState extends State<ItemForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Item Name'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),

          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Item Weight/Count'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a value';
              }
              return null;
            },
          ),

          TextFormField(
            decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Expiry Date'
            ),
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
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Entering Item')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Screen for adding a new item.
class AddItemScreen extends StatelessWidget {
  /// Result of attempting to lookup this product.
  final ProductLookupResult lookupResult; ///could be null

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
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ItemForm()
            ],
          ),
        ),
      ),
    );
  }
}
