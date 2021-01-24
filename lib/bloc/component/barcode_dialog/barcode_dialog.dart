import 'package:flutter/material.dart';

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
            return Center(
              child: Column(
                children: [
                  const Text('Error!'),
                  Text(snapshot.error.toString()),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
