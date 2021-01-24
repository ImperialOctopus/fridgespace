import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bubble/bubble_bloc.dart';
import '../../bloc/bubble/bubble_event.dart';
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
  bool submitEnabled = false;

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
                mainAxisAlignment: MainAxisAlignment.center,
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
                    onChanged: (value) =>
                        setState(() => submitEnabled = value.length == 5),
                    maxLength: 5,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  ElevatedButton(
                      child: const Text('Join!'),
                      onPressed: submitEnabled
                          ? () async {
                              final future =
                                  RepositoryProvider.of<BubbleJoinService>(
                                          context)
                                      .joinBubble(_textController.text);
                              setState(() {
                                loading = true;
                              });
                              try {
                                await future;

                                /// Pop success message.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Successfully joined a new bubble!')),
                                );
                                BlocProvider.of<BubbleBloc>(context)
                                    .add(const LoadBubbles());
                                Navigator.of(context).pop();
                              } on JoinBubbleException catch (e) {
                                setState(() {
                                  loading = false;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Failed to join bubble!\nError: ' +
                                            e.message),
                                  ),
                                );
                              }
                            }
                          : null)
                ],
              ),
            ),
    );
  }
}
