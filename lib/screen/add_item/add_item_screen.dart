import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/foodlist/foodlist_bloc.dart';
import '../../bloc/foodlist/foodlist_event.dart';
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
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameController.text = widget.lookupResult?.name;
    _quantityController = TextEditingController();
    _quantityController.text = widget.lookupResult?.quantity;
  }

  //Method for showing the date picker
  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(
                1950), //what will be the up to supported date in picker
            lastDate: DateTime.now().add(const Duration(days: 3650)))
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 20),
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(_selectedDate ==
                        null //ternary expression to check if date is null
                    ? 'No date chosen!'
                    : 'Expiry Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
                RaisedButton(
                  child: const Text('Add Date'),
                  onPressed: _pickDateDialog,
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
          ),
        ),
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
        expires: _selectedDate,
        shared: false,
      );

      BlocProvider.of<FoodlistBloc>(context).add(AddFoodItem(foodItem: item));
      Navigator.of(context).pop();
    }
  }
}
