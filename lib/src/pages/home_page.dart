import 'dart:io';

import 'package:flutter/material.dart';

import 'package:n_gamepad/n_gamepad.dart';

import '../models/game.dart';

import '../widgets/broadcast_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('nx Gamepad'),
        centerTitle: true,
      ),
      body: StreamBuilder<InternetAddress>(
        stream: Connection.service.controller.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: Connection.service.addresses
                  .map<Widget>(_buildTextButton)
                  .toList(),
            ),
          );
        },
      ),
      floatingActionButton: BroadcastButton(
        game: GameExample([255, 255, 255]),
      ),
    );
  }

  Widget _buildTextButton(InternetAddress address) {
    return TextButton(
      onPressed: () => Connection.service.select(address),
      child: Text(address.address),
    );
  }
}
