/// Exception for failures in looking up barcodes in an image.
class BarcodeLookupException implements Exception {
  /// Error message.
  final String message;

  /// Exception for failures in looking up barcodes in an image.
  const BarcodeLookupException([this.message = '']);
}
