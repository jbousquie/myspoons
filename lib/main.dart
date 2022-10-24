import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tracker.dart';

// https://www.freecodecamp.org/news/provider-pattern-in-flutter/

void main() {
  const myApp = MyApp();
  runApp(myApp);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: SpoonTracker(),
          )
        ],
        child: MaterialApp(
          title: 'My Spoons',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'My Spoons'),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});
  void _updateEnergyRate(BuildContext context, double value) {
    Provider.of<SpoonTracker>(context, listen: false).updateEnergyRate(value);
  }

  @override
  Widget build(BuildContext context) {
    double energyRate = Provider.of<SpoonTracker>(context).energyRate;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: buildSlider(context, energyRate),
      floatingActionButton:
          FloatingActionButton(onPressed: () => _updateEnergyRate(context, 6)),
    );
  }

  buildSlider(BuildContext context, double energyRate) {
    return Slider(
      value: energyRate,
      max: 100,
      onChanged: (double value) => {_updateEnergyRate(context, value)},
    );
  }
}
