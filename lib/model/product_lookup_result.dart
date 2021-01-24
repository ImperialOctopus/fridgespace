import 'package:flutter/material.dart';

/// Result from looking up a product in the food database.
class ProductLookupResult {
  /// Name of product.
  final String name;

  /// Quantity of product.
  final String quantity;

  /// Result from looking up a product in the food database.
  const ProductLookupResult({
    @required this.name,
    @required this.quantity,
  });
}
