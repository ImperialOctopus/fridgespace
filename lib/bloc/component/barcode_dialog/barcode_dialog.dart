import 'package:flutter/material.dart';

import '../../../exception/barcode_lookup_exception.dart';

/// Dialog to display while waiting for file to load.
class BarcodeDialog extends StatefulWidget {
  /// Future we're waiting for.
  final Future<dynamic> future;

  /// Dialog to display while waiting for file to load.
  const BarcodeDialog({@required this.future});

  @override
  State<StatefulWidget> createState() => _BarcodeDialogState();
}

class _BarcodeDialogState extends State<BarcodeDialog> {
  @override
  void initState() {
    super.initState();
    widget.future.then((dynamic _) => Navigator.of(context).pop(true));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: widget.future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return AlertDialog(
              title: const Text('Item lookup failed.'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (snapshot.error is BarcodeLookupException)
                    Text((snapshot.error as BarcodeLookupException).message),
                ],
              ),
              actions: [
                FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                FlatButton(
                  child: const Text('Enter Manually'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          }
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Looking up item...'),
                ),
              ],
            ),
          );
        });
  }
}
