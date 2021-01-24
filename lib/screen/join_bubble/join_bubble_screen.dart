import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bubble/bubble_bloc.dart';
import '../../bloc/bubble/bubble_event.dart';
import '../../extension/uppercase_text_formatter.dart';

/// Page to join a bubble.
class JoinBubbleScreen extends StatefulWidget {
  /// Page to join a bubble.
  const JoinBubbleScreen();

  @override
  _JoinBubbleScreenState createState() => _JoinBubbleScreenState();
}

class _JoinBubbleScreenState extends State<JoinBubbleScreen> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
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
              onPressed: () => BlocProvider.of<BubbleBloc>(context)
                  .add(JoinBubble(code: _textController.text)),
            )
          ],
        ),
      ),
    );
  }
}
