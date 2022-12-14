// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myspoons/model.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

// https://stackoverflow.com/questions/44816042/flutter-read-text-file-from-assets/54133627#54133627

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key, required this.title, required this.chartType})
      : super(key: key);
  final String title;
  final ChartType chartType;
  @override
  ChartPageState createState() {
    return ChartPageState();
  }
}

class ChartPageState extends State<ChartPage> {
  late WebViewController _controller;
  static String htmlFile = 'lib/assets/charts.html';
  static String jsLibFile = 'lib/assets/chart.umd.min.js';
  static String jsLib2File = 'lib/assets/chartjs-plugin-datalabels.min.js';
  static String jsLib3File =
      'lib/assets/chartjs-adapter-date-fns.bundle.min.js';
  static String jsCodeFile = 'lib/assets/mycharts.js';
  String htmlCode = '';
  String jsLib = '';
  String jsLib2 = '';
  String jsLib3 = '';
  String jsCode = '';

  @override
  Widget build(BuildContext context) {
    final Settings settings = Provider.of<Settings>(context, listen: false);
    final maxSpoonNb = settings.maxSpoonNb;
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: WebView(
          initialUrl: 'about:blank',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            webViewController.clearCache();
            _controller = webViewController;
            _loadHtmlFromAssets();
          },
          onPageFinished: (String _) async {
            String data = await getData();
            final chartType = widget.chartType;
            runJS(chartType.type, maxSpoonNb, data, chartType.labels,
                chartType.title, chartType.description);
          },
        ));
  }

  void _loadHtmlFromAssets() async {
    htmlCode = await rootBundle.loadString(htmlFile);
    jsLib = await rootBundle.loadString(jsLibFile);
    jsLib2 = await rootBundle.loadString(jsLib2File);
    jsLib3 = await rootBundle.loadString(jsLib3File);
    jsCode = await rootBundle.loadString(jsCodeFile);
    _controller.loadUrl(Uri.dataFromString(htmlCode,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  Future<String> getData() async {
    SpoonTracker provider = Provider.of<SpoonTracker>(context, listen: false);
    String data = await provider.getDataFromFile();
    return data;
  }

  runJS(int chartType, int maxSpoonNb, String data, String labels, String title,
      String description) {
    const htmlEscapeMode = HtmlEscapeMode(
        name: 'custom',
        escapeLtGt: false,
        escapeQuot: true,
        escapeSlash: true,
        escapeApos: true);
    const HtmlEscape htmlEscape = HtmlEscape(htmlEscapeMode);

    // first run the JS files
    _controller.runJavascript(jsLib);
    _controller.runJavascript(jsLib2);
    _controller.runJavascript(jsLib3);
    _controller.runJavascript(jsCode);

    final String escaped = data.replaceAll('\n', '\\n');
    final String htmlEscaped = htmlEscape.convert(escaped);
    final String htmlTitle = htmlEscape.convert(title);
    final String htmlDescription = htmlEscape.convert(description);
    final String jsString =
        'init($chartType,$maxSpoonNb,\'$htmlEscaped\',\'$labels\',\'$htmlTitle\',\'$htmlDescription\');';
    _controller.runJavascript(jsString);
  }
}

class ChartType {
  ChartType({required this.type, required this.title});
  final int type;
  final String title;
  String description = '';
  String labels = '';
}
