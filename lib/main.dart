import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'model.dart';
import 'settingsPage.dart';
import 'chartsPage.dart';

// https://www.freecodecamp.org/news/provider-pattern-in-flutter/
// https://www.flaticon.com/free-icon/spoon_96164#

// https://greymag.medium.com/flutter-orientation-lock-portrait-only-c98910ebd769

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => {runApp(const MyApp())});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SpoonTracker spoonTracker = SpoonTracker();
    Settings settings = Settings();
    spoonTracker.linkSettings(settings);
    spoonTracker.checkLastSession();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: spoonTracker),
          ChangeNotifierProvider.value(value: settings),
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
  static String iconButtonFile = 'lib/assets/icons/kitchen-spoon-icon.png';
  static String imageIconFile = 'lib/assets/icons/spoon.png';
  final buttonIcon = ImageIcon(AssetImage(iconButtonFile));
  final commentController = TextEditingController();

  MyHomePage({super.key, required this.title});

  void _updateEnergyRate(BuildContext context, int value) {
    Provider.of<SpoonTracker>(context, listen: false).updateEnergyRate(value);
  }

  void _logData(BuildContext context) {
    String comment = commentController.text;
    Provider.of<SpoonTracker>(context, listen: false).comment = comment;
    Provider.of<SpoonTracker>(context, listen: false).logData();
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: [
        IconButton(
            onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ChartsPage(title: 'Charts');
                  }))
                },
            icon: const Icon(Icons.show_chart)),
        IconButton(
            onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SettingsPage(title: 'Settings');
                  }))
                },
            icon: const Icon(Icons.settings))
      ]),
      body: Center(child: SingleChildScrollView(child: buildContent(context))),
      floatingActionButton: FloatingActionButton(
          child: buttonIcon,
          onPressed: () {
            _logData(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Spooned !"), duration: Duration(seconds: 2), backgroundColor: Colors.blueAccent));
          }),
      //resizeToAvoidBottomInset: false,
    );
  }

  buildContent(BuildContext context) {
    int energyRate = Provider.of<SpoonTracker>(context, listen: true).energyRate;
    int spoonNb = Provider.of<SpoonTracker>(context, listen: true).spoonNb;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Text('${energyRate.round()}'),
        Row(children: [
          Expanded(child: buildSpoonGrid(spoonNb, context), flex: 2),
          Expanded(child: buildSlider(context, energyRate))
        ]),
        buildInputField(context)
      ],
    );
  }

  ImageIcon _spoonIcon(int colorIndex, double ratio) {
    return ImageIcon(
      AssetImage(imageIconFile),
      color: Color.fromARGB(95 + colorIndex * (20 * ratio).round(), 40 + colorIndex * (4 * ratio).round(),
          28 + colorIndex * (27 * ratio).round(), 50 + colorIndex * (4 * ratio).round()),
    );
  }

  buildSpoonGrid(int spoonNb, BuildContext context) {
    final maxSpoonNb = Provider.of<Settings>(context, listen: true).maxSpoonNb;
    final ratio = 8 / maxSpoonNb;
    final spoonIcon = _spoonIcon(spoonNb, ratio);
    return Transform(
        transform: Matrix4.rotationY(-pi),
        alignment: Alignment.center,
        child: SizedBox(
            height: 500,
            width: 200,
            child: GridView.count(
                padding: const EdgeInsets.all(20),
                mainAxisSpacing: 10 * ratio,
                crossAxisSpacing: 15 * ratio,
                crossAxisCount: 2,
                reverse: true,
                childAspectRatio: 1 / ratio,
                children: List.generate(spoonNb, (index) {
                  return spoonIcon;
                }))));
  }

  buildInputField(BuildContext context) {
    String comment = Provider.of<SpoonTracker>(context, listen: true).comment;
    String dateString = Provider.of<SpoonTracker>(context, listen: true).dateString;
    final String today = DateTime.now().toString().substring(0, 10);
    final String dayFromDateString = dateString.substring(0, 10);
    String label;
    if (today != dayFromDateString) {
      label = 'No spoon yet today';
    } else {
      label = 'Last spoon at ${dateString.substring(11, 16)}';
    }
    final textfield = TextField(
      controller: commentController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
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
