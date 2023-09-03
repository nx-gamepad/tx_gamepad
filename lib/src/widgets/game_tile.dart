import 'dart:io';

import 'package:flutter/material.dart';
import 'package:n_gamepad/n_gamepad.dart';

import 'broadcast_button.dart';

class GameTile extends StatelessWidget {
  const GameTile({required this.game, super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 200.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ExpansionTile(
          trailing: BroadcastButton(game: game),
          title: Text('${game.name}'),
          children: Connection.service.addresses.map(_buildListTile).toList(),
        ),
      ),
    );
  }

  Widget _buildListTile(InternetAddress address) {
    return ListTile(
      title: Text(address.address),
      dense: true,
      onTap: () => Connection.service.select(address),
    );
  }
}
