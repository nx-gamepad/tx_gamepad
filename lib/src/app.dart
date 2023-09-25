import 'package:flutter/material.dart';

import 'pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      title: 'nx Gamepad',
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
