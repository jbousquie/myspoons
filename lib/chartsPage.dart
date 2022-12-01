// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myspoons/model.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

// https://stackoverflow.com/questions/44816042/flutter-read-text-file-from-assets/54133627#54133627

class ChartsPage extends StatefulWidget {
  const ChartsPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  ChartsPageState createState() {
    return ChartsPageState();
  }
}

class ChartsPageState extends State<ChartsPage> {
  late WebViewController _controller;
  static String htmlFile = 'lib/assets/charts.html';
  static String jsLibFile = 'lib/assets/chart.min.js';
  static String jsCodeFile = 'lib/assets/mycharts.js';
  String htmlCode = '';
  String jsLib = '';
  String jsCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Charts')),
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
            runJS(data);
          },
        ));
  }

  void _loadHtmlFromAssets() async {
    htmlCode = await rootBundle.loadString(htmlFile);
    jsLib = await rootBundle.loadString(jsLibFile);
    jsCode = await rootBundle.loadString(jsCodeFile);
    _controller
        .loadUrl(Uri.dataFromString(htmlCode, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }

  Future<String> getData() async {
    SpoonTracker provider = Provider.of<SpoonTracker>(context, listen: false);
    String data = await provider.getDataFromFile();
    return data;
  }

  runJS(String data) {
    // first run the JS File
    _controller.runJavascript(jsLib);
    _controller.runJavascript(jsCode);

    final String escaped = data.replaceAll('\n', '\\n');
    final String jsString = 'init(\'$escaped\');';
    _controller.runJavascript(jsString);
  }
}
