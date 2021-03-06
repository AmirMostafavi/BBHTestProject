import 'package:bbh_test_app/widgets/screens/album_screen.dart';
import 'package:bbh_test_app/widgets/screens/post_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/screens/home_screen.dart';
import 'resources/app_strings.dart';

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
    return CupertinoApp(
      title: AppStrings.appName,

      /// ----- Routes -----
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/album-screen': (context) => const AlbumScreen(),
        '/post-screen': (context) => const PostScreen(),
      },
    );
  }
}
