import 'package:flutter/material.dart';

import 'package:n_gamepad/n_gamepad.dart';

class MenuLayout extends Layout {
  MenuLayout(List<int> data) : super(_MenuLayout(data));
}

class _MenuLayout extends StatelessWidget {
  const _MenuLayout(this.data);

  final List<int> data;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Build the user interface with the received data.'),
    );
  }
}
