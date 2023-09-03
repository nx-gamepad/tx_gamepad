import 'package:flutter/material.dart';

import 'package:n_gamepad/n_gamepad.dart';

class BroadcastButton extends StatefulWidget {
  const BroadcastButton({super.key, required this.game});

  final Game game;

  @override
  State<BroadcastButton> createState() => _BroadcastButtonState();
}

class _BroadcastButtonState extends State<BroadcastButton> {
  late bool state;

  @override
  void initState() {
    super.initState();
    state = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.game.context = context;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (state) {
      return IconButton(
        onPressed: stopBroadcast,
        icon: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            color: Colors.grey,
            strokeWidth: 2.0,
          ),
        ),
      );
    }
    return IconButton(
      onPressed: startBroadcast,
      icon: const Icon(Icons.broadcast_on_home),
    );
  }

  void startBroadcast() {
    Connection.service.startBroadcast(widget.game, onBroadcastStop);
    setState(() => state = true);
  }

  void stopBroadcast() {
    Connection.service.stopBroadcast();
  }

  void onBroadcastStop() {
    setState(() => state = false);
  }
}
