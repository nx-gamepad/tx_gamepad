import 'package:flutter/material.dart';

import 'package:n_gamepad/n_gamepad.dart';

class MenuComponent extends Component {
  MenuComponent(List<int> data) : super(MenuLayout(data));
}

class MenuLayout extends StatelessWidget {
  const MenuLayout(
    this.data, {
    super.key,
  });

  final List<int> data;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Build the user interface with the received data.'),
    );
  }
}
