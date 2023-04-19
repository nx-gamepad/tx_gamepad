import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:n_gamepad/n_gamepad.dart';

import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[DeviceOrientation.landscapeLeft],
  );

  await Connection.instantiate();

  runApp(const App());
}
