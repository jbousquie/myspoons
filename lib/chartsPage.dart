// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Charts')),
        body: WebView(
          initialUrl: 'about: blank',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            webViewController.clearCache();
            _controller = webViewController;
            _loadHtmlFromAssets();
          },
          onPageFinished: (String _) {
            _runJS("TOTOTOTO");
          },
        ));
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('lib/assets/charts.html');
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  _runJS(String data) {
    _controller.runJavascript('fromFlutter("$data");');
  }
}
