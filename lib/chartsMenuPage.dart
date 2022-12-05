// ignore: file_names
import 'package:flutter/material.dart';
import 'chartPage.dart';

class ChartsMenuPage extends StatelessWidget {
  const ChartsMenuPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Charts Menu')),
        body: buildContent(context));
  }

  destinationPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const ChartPage(title: 'Charts');
    }));
  }

  Widget buildContent(BuildContext context) {
    List<Widget> menuList = [
      TextButton(
        child: const Text('Chart 1'),
        onPressed: () => destinationPage(context),
      ),
      TextButton(
        child: const Text('Chart 2'),
        onPressed: () => destinationPage(context),
      ),
      TextButton(
        child: const Text('Chart 3'),
        onPressed: () => destinationPage(context),
      ),
      TextButton(
        child: const Text('Chart 4'),
        onPressed: () => destinationPage(context),
      ),
      TextButton(
        child: const Text('Chart 5'),
        onPressed: () => destinationPage(context),
      ),
      TextButton(
        child: const Text('Chart 6'),
        onPressed: () => destinationPage(context),
      ),
    ];

    GridView grid = GridView.count(
      crossAxisCount: 3,
      children: menuList,
    );
    return grid;
  }
}
