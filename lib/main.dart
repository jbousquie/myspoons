import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tracker.dart';

// https://www.freecodecamp.org/news/provider-pattern-in-flutter/

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => SpoonTracker(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Spoons',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'My Spoons'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: FloatingActionButton(onPressed: updateEner),
    );
  }
}
