import 'package:flutter/material.dart';
import 'package:recipe_calculator/pages/HomePage.dart';

import 'models/Data.dart';

void main() async {
  // App init
  WidgetsFlutterBinding
      .ensureInitialized(); // required if using async/await in main
  await Data().startup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        // notice "hot reload" button
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
