import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tracker.dart';

// https://www.freecodecamp.org/news/provider-pattern-in-flutter/
// https://flutter.syncfusion.com/#/
// https://www.flaticon.com/free-icon/spoon_96164#

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
          home: MyHomePage(title: 'My Daily Spoons'),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final buttonIcon = const ImageIcon(AssetImage('lib/assets/icons/kitchen-spoon-icon.png'));
  final commentController = TextEditingController();

  MyHomePage({super.key, required this.title});

  void _updateEnergyRate(BuildContext context, int value) {
    Provider.of<SpoonTracker>(context, listen: false).updateEnergyRate(value);
  }

  void _logData(BuildContext context) {
    int energyRate = Provider.of<SpoonTracker>(context, listen: false).energyRate;
    String comment = commentController.text;
    Provider.of<SpoonTracker>(context, listen: false).comment = comment;
    String dateString = DateTime.now().toString().substring(0, 19);
    Provider.of<SpoonTracker>(context, listen: false).dateString = dateString;
    Provider.of<SpoonTracker>(context, listen: false).logData(dateString, energyRate, comment);
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: SingleChildScrollView(child: buildContent(context))),
      floatingActionButton: FloatingActionButton(child: buttonIcon, onPressed: () => _logData(context)),
      //resizeToAvoidBottomInset: false,
    );
  }

  buildContent(BuildContext context) {
    int energyRate = Provider.of<SpoonTracker>(context).energyRate;
    int spoonNb = Provider.of<SpoonTracker>(context).spoonNb;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Text('${energyRate.round()}'),
        Row(children: [
          Expanded(child: buildSpoonGrid(spoonNb), flex: 2),
          Expanded(child: buildSlider(context, energyRate))
        ]),
        buildInputField(context)
      ],
    );
  }

  ImageIcon _spoonIcon(int colorIndex) {
    return ImageIcon(const AssetImage('lib/assets/icons/spoon.png'),
        color: Color.fromARGB(120 + colorIndex * 10, 80, 28 * colorIndex, 80));
  }

  buildSpoonGrid(int spoonNb) {
    final spoonIcon = _spoonIcon(spoonNb);
    return SizedBox(
        height: 500,
        width: 200,
        child: GridView.count(
            padding: const EdgeInsets.all(20),
            mainAxisSpacing: 10,
            crossAxisSpacing: 20,
            crossAxisCount: 2,
            reverse: true,
            children: List.generate(spoonNb, (index) {
              return spoonIcon;
            })));
  }

  buildInputField(BuildContext context) {
    String comment = Provider.of<SpoonTracker>(context).comment;
    String dateString = Provider.of<SpoonTracker>(context).dateString;
    final textfield = TextField(
      controller: commentController,
      autofocus: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Last record at ${dateString.substring(11)}',
          hintText: comment,
          hintStyle: const TextStyle(fontStyle: FontStyle.italic)),
    );
    return textfield;
  }

  buildSlider(BuildContext context, int energyRate) {
    Widget slider = SizedBox(
        height: 500,
        child: RotatedBox(
            quarterTurns: -1,
            child: Slider(
              label: '$energyRate',
              value: energyRate.toDouble(),
              max: 100,
              onChanged: (double value) => {_updateEnergyRate(context, value.toInt())},
            )));

    Widget sliderTheme = SliderTheme(
        data: const SliderThemeData(
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 35),
            trackHeight: 30,
            showValueIndicator: ShowValueIndicator.onlyForContinuous),
        child: slider);
    return sliderTheme;
  }
}
