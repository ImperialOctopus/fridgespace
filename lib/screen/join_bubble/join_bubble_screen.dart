import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exception/join_bubble_exception.dart';
import '../../extension/uppercase_text_formatter.dart';
import '../../service/bubble_join_service.dart';

/// Page to join a bubble.
class JoinBubbleScreen extends StatefulWidget {
  /// Page to join a bubble.
  const JoinBubbleScreen();

  @override
  _JoinBubbleScreenState createState() => _JoinBubbleScreenState();
}

class _JoinBubbleScreenState extends State<JoinBubbleScreen> {
  final _textController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: (loading)
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  const Text('Join a Bubble'),
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                      UpperCaseTextFormatter(),
                    ],
                    maxLength: 5,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  ElevatedButton(
                      child: const Text('Join!'),
                      onPressed: () async {
                        final future =
                            RepositoryProvider.of<BubbleJoinService>(context)
                                .joinBubble(_textController.text);
                        setState(() {
                          loading = true;
                        });
                        try {
                          await future;

                          /// Pop success message.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Successfully joined a new bubble!')),
                          );
                          Navigator.of(context).pop();
                        } on JoinBubbleException catch (e) {
                          loading = false;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to join bubble!\nError: ' +
                                  e.message),
                            ),
                          );
                        }
                      })
                ],
              ),
            ),
    );
  }
}
