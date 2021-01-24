import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/bubble_join_service.dart';

/// Page to join a bubble.
class CreateBubbleScreen extends StatefulWidget {
  /// Page to join a bubble.
  const CreateBubbleScreen();

  @override
  _CreateBubbleScreenState createState() => _CreateBubbleScreenState();
}

class _CreateBubbleScreenState extends State<CreateBubbleScreen> {
  final _textController = TextEditingController();

  bool loading = false;
  bool submitEnabled = false;
  String roomName;
  String roomCode;

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
          : (roomCode == null)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Create a Bubble',
                          style: Theme.of(context).textTheme.headline3),
                      Container(height: 30),
                      const Text("Enter your new bubble's name",
                          style: TextStyle(fontSize: 18)),
                      Container(height: 15),
                      TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(),
                          ),
                        ),
                        textAlign: TextAlign.center,
                        onChanged: (value) =>
                            setState(() => submitEnabled = value.isNotEmpty),
                        maxLength: 64,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      ElevatedButton(
                          child: const Text('Create!'),
                          onPressed: submitEnabled
                              ? () async {
                                  final _roomCode =
                                      RepositoryProvider.of<BubbleJoinService>(
                                              context)
                                          .createBubble(_textController.text);
                                  setState(() {
                                    loading = true;
                                  });
                                  try {
                                    await print(await _roomCode);
                                    await RepositoryProvider.of<
                                            BubbleJoinService>(context)
                                        .joinBubble(await _roomCode);
                                    roomName = _textController.text;
                                    roomCode = await _roomCode;

                                    /// Pop success message.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Successfully joined a new bubble!')),
                                    );
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    setState(() {
                                      loading = false;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Failed to create bubble! Please try again later.'),
                                      ),
                                    );
                                  }
                                }
                              : null)
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(roomName,
                          style: Theme.of(context).textTheme.headline3),
                      Container(height: 30),
                      Text(roomCode,
                          style: Theme.of(context).textTheme.subtitle1)
                    ],
                  ),
                ),
    );
  }
}
