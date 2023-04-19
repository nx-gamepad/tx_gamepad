import 'package:flutter/material.dart';

import 'package:n_gamepad/n_gamepad.dart';

class BroadcastButton extends StatefulWidget {
  const BroadcastButton({super.key, required this.game});

  final Game game;

  @override
  State<BroadcastButton> createState() => _BroadcastButtonState();
}

class _BroadcastButtonState extends State<BroadcastButton> {
  late bool _state;

  @override
  void initState() {
    super.initState();
    _state = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.game.context = context;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_state) {
      return FloatingActionButton(
        onPressed: _stopBroadcast,
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.0,
          ),
        ),
      );
    }
    return FloatingActionButton(
      onPressed: _startBroadcast,
      child: const Icon(Icons.broadcast_on_home),
    );
  }

  void _startBroadcast() {
    Connection.service.startBroadcast(widget.game, _onBroadcastStop);
    setState(() => _state = true);
  }

  void _stopBroadcast() {
    Connection.service.stopBroadcast();
  }

  void _onBroadcastStop() {
    setState(() => _state = false);
  }
}
