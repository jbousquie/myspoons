// ignore: file_names
import 'package:flutter/material.dart';
import 'package:myspoons/dataExportPage.dart';
import 'chartPage.dart';
import 'model.dart';
import 'intl.dart';
import 'package:provider/provider.dart';

class ChartsMenuPage extends StatelessWidget {
  const ChartsMenuPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final Localization local =
        Provider.of<Settings>(context, listen: false).local;
    final String titleExport = local.txt('chartsmenu_export');
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: buildContent(context),
      floatingActionButton: SizedBox(
          width: 100,
          height: 100,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DataExportPage(title: titleExport);
              }));
            },
            child: Text(
              titleExport,
              textAlign: TextAlign.center,
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  destinationPage(BuildContext context, String title, ChartType chartType) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ChartPage(title: title, chartType: chartType);
    }));
  }

  Widget buildContent(BuildContext context) {
    final Localization local =
        Provider.of<Settings>(context, listen: false).local;
    final String title = local.txt('charts_title');

    List<Widget> menuList = [
      TextButton(
        child: Text(
          local.txt('chartsmenu_chart1'),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          final ChartType chartType =
              ChartType(type: 1, title: local.txt('chartsmenu_chart1'));
          chartType.description = local.txt('chart1_descr');

          destinationPage(context, title, chartType);
        },
      ),
      TextButton(
        child: Text(
          local.txt('chartsmenu_chart2'),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          final ChartType chartType =
              ChartType(type: 2, title: local.txt('chartsmenu_chart2'));
          chartType.description = local.txt('chart2_descr');
          destinationPage(context, title, chartType);
        },
      ),
      TextButton(
        child: Text(
          local.txt('chartsmenu_chart3'),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          final ChartType chartType =
              ChartType(type: 3, title: local.txt('chartsmenu_chart3'));
          chartType.description = local.txt('chart3_descr');
          destinationPage(context, title, chartType);
        },
      ),
      TextButton(
        child: Text(
          local.txt('chartsmenu_chart4'),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          final ChartType chartType =
              ChartType(type: 4, title: local.txt('chartsmenu_chart4'));
          chartType.labels = local.jsonMap('week_labels');
          chartType.description = local.txt('chart4_descr');
          destinationPage(context, title, chartType);
        },
      ),
      TextButton(
        child: Text(
          local.txt('chartsmenu_chart5'),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          final ChartType chartType =
              ChartType(type: 5, title: local.txt('chartsmenu_chart5'));
          chartType.labels = local.jsonMap('week_labels');
          chartType.description = local.txt('chart5_descr');
          destinationPage(context, title, chartType);
        },
      ),
      TextButton(
        child: Text(
          local.txt('chartsmenu_chart6'),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          final ChartType chartType =
              ChartType(type: 6, title: local.txt('chartsmenu_chart6'));
          chartType.description = local.txt('chart6_descr');
          destinationPage(context, title, chartType);
        },
      ),
      TextButton(
        child: Text(
          local.txt('chartsmenu_chart7'),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          final ChartType chartType =
              ChartType(type: 7, title: local.txt('chartsmenu_chart7'));
          chartType.description = local.txt('chart7_descr');
          destinationPage(context, title, chartType);
        },
      ),
      TextButton(
        child: Text(
          local.txt('chartsmenu_chart8'),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          final ChartType chartType =
              ChartType(type: 8, title: local.txt('chartsmenu_chart8'));
          chartType.description = local.txt('chart8_descr');
          destinationPage(context, title, chartType);
        },
      ),
      TextButton(
        child: Text(
          local.txt('chartsmenu_chart9'),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          final ChartType chartType =
              ChartType(type: 9, title: local.txt('chartsmenu_chart9'));
          chartType.description = local.txt('chart9_descr');
          destinationPage(context, title, chartType);
        },
      ),
    ];

    GridView grid = GridView.count(
      crossAxisCount: 3,
      children: menuList,
    );

    return grid;
  }
}
