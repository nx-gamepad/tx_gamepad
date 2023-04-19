import 'package:flutter/widgets.dart';

import 'package:n_gamepad/n_gamepad.dart';

import '../layouts/menu_layout.dart';

class GameExample extends Game {
  GameExample(super.code);

  @override
  Widget buildLayout(StatePacket packet) {
    switch (GameState.values[packet.state]) {
      case GameState.menu:
        return MenuLayout(packet.data);
    }
  }

  @override
  int get states => GameState.values.length;

  @override
  int get updates => 0;
}

enum GameState {
  menu,
}
