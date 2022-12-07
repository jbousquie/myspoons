// ignore: file_names
import 'package:flutter/material.dart';
import 'chartPage.dart';
import 'model.dart';
import 'intl.dart';
import 'package:provider/provider.dart';

class ChartsMenuPage extends StatelessWidget {
  const ChartsMenuPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)), body: buildContent(context));
  }

  destinationPage(BuildContext context, int chartType, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ChartPage(title: title, chartType: chartType);
    }));
  }

  Widget buildContent(BuildContext context) {
    final Localization local =
        Provider.of<Settings>(context, listen: false).local;
    List<Widget> menuList = [
      TextButton(
        child: Text(local.txt('chartsmenu_chart1')),
        onPressed: () =>
            destinationPage(context, 1, local.txt('chartsmenu_chart1')),
      ),
      TextButton(
        child: Text(local.txt('chartsmenu_chart2')),
        onPressed: () =>
            destinationPage(context, 2, local.txt('chartsmenu_chart2')),
      ),
      TextButton(
        child: Text(local.txt('chartsmenu_chart3')),
        onPressed: () =>
            destinationPage(context, 3, local.txt('chartsmenu_chart3')),
      ),
      TextButton(
        child: Text(local.txt('chartsmenu_chart4')),
        onPressed: () =>
            destinationPage(context, 4, local.txt('chartsmenu_chart4')),
      ),
      TextButton(
        child: Text(local.txt('chartsmenu_chart5')),
        onPressed: () =>
            destinationPage(context, 5, local.txt('chartsmenu_chart5')),
      ),
      TextButton(
        child: Text(local.txt('chartsmenu_chart6')),
        onPressed: () =>
            destinationPage(context, 6, local.txt('chartsmenu_chart6')),
      ),
    ];

    GridView grid = GridView.count(
      crossAxisCount: 3,
      children: menuList,
    );
    return grid;
  }
}
