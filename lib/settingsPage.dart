// ignore: file_names
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      /*
        body: Center(
          child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back')),
        )*/
    );
  }
}
