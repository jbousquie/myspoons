import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tracker.dart';

// https://www.freecodecamp.org/news/provider-pattern-in-flutter/
// https://flutter.syncfusion.com/#/

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
          home: MyHomePage(title: 'My Spoons'),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final commentController = TextEditingController();
  MyHomePage({super.key, required this.title});

  void _updateEnergyRate(BuildContext context, double value) {
    Provider.of<SpoonTracker>(context, listen: false).updateEnergyRate(value);
  }

  void _logData(BuildContext context) {
    double energyRate =
        Provider.of<SpoonTracker>(context, listen: false).energyRate;
    String comment = commentController.text;
    Provider.of<SpoonTracker>(context, listen: false)
        .logData(energyRate, comment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: buildContent(context),
      floatingActionButton:
          FloatingActionButton(onPressed: () => _logData(context)),
    );
  }

  buildContent(BuildContext context) {
    double energyRate = Provider.of<SpoonTracker>(context).energyRate;
    return Column(
      children: [
        Expanded(child: buildSlider(context, energyRate)),
        Text('${energyRate.round()}'),
        buildInputField(context)
      ],
    );
  }

  buildInputField(BuildContext context) {
    String comment = Provider.of<SpoonTracker>(context).comment;
    final textfield = TextField(
      controller: commentController,
      autofocus: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'comment',
          hintText: comment,
          hintStyle: const TextStyle(fontStyle: FontStyle.italic)),
    );
    return textfield;
  }

  buildSlider(BuildContext context, double energyRate) {
    Widget slider = RotatedBox(
        quarterTurns: -1,
        child: Slider(
          value: energyRate,
          max: 100,
          onChanged: (double value) => {_updateEnergyRate(context, value)},
        ));

    Widget sliderTheme = SliderTheme(
        data: const SliderThemeData(
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 45),
            trackHeight: 50),
        child: slider);
    return sliderTheme;
  }
}
