import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_screen.dart';
import 'resources/app_strings.dart';
import 'utils/size_utils.dart';

void main() {
  runApp(const BBHTestApp());
}

class BBHTestApp extends StatelessWidget {
  const BBHTestApp({Key? key}) : super(key: key);

  /// ----- Widget Lifecycle -----

  @override
  Widget build(BuildContext context) {
    /// Limit device orientation to portrait
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    /// --- App ---
    return const CupertinoApp(
      title: AppStrings.appName,
      home: HomeScreen(title: 'Flutter Demo Home Page'),
    );
  }
}
