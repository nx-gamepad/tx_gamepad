import 'dart:io';

import 'package:flutter/material.dart';

import 'package:n_gamepad/n_gamepad.dart';
import 'package:t_gamepad/t_gamepad.dart';

import '../models/game.dart';

import '../widgets/game_tile.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final list = <Game>[
    Controller(<int>[0, 0, 0]),
    Minecraft(<int>[0, 0, 1]),
  ];

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
          return ListView(
            children: <Widget>[
              for (Game game in list) GameTile(game: game),
            ],
          );
        },
      ),
    );
  }
}
