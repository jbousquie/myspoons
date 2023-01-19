// ignore: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:myspoons/model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'intl.dart';

class DataExportPage extends StatelessWidget {
  const DataExportPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    final Localization local = Provider.of<Settings>(context, listen: true).local;
    return Scaffold(appBar: AppBar(title: Text(local.txt('chartsmenu_export'))), body: buildExportContent(context));
  }

  Widget buildButtonSave(BuildContext context) {
    final Localization local = Provider.of<Settings>(context, listen: true).local;
    final TextButton buttonSave = TextButton(
      child: Text(local.txt('button_save')),
      onPressed: () {
        _saveFile(context);
      },
    );
    return buttonSave;
  }

  Widget buildButtonSend(BuildContext context) {
    final Localization local = Provider.of<Settings>(context, listen: true).local;
    final SpoonTracker provider = Provider.of<SpoonTracker>(context, listen: true);
    final TextButton buttonSave = TextButton(
      child: Text(local.txt('button_send')),
      onPressed: () async {
        String msg = await _sendFile(context);
        provider.exportReport = msg;
      },
    );
    return buttonSave;
  }

  Widget buildExportReport(BuildContext context) {
    final SpoonTracker provider = Provider.of<SpoonTracker>(context, listen: false);
    final msg = provider.exportReport;
    final Text reportMsg = Text(msg);
    return reportMsg;
  }

  void _saveFile(BuildContext context) async {
    final SpoonTracker provider = Provider.of<SpoonTracker>(context, listen: false);
    final String path = await provider.filePath;
    final params = SaveFileDialogParams(sourceFilePath: path);
    await FlutterFileDialog.saveFile(params: params);
  }

  Future<String> _sendFile(BuildContext context) async {
    final SpoonTracker provider = Provider.of<SpoonTracker>(context, listen: false);
    final Localization local = Provider.of<Settings>(context, listen: false).local;
    final String data = await provider.getDataFromFile();
    final String url = provider.collectURL;
    final uri = Uri.parse(url);
    final request = http.MultipartRequest('POST', uri);
    request.fields['uuid'] = await provider.uuid;
    request.fields['gender'] = 'F';
    request.fields['birth'] = '1990';
    request.fields['lang'] = 'EN';
    request.files.add(
        http.MultipartFile.fromString('data', data, contentType: MediaType('text', 'csv'), filename: 'myspoons.csv'));
    final response = await request.send();
    String msg;
    if (response.statusCode == 200) {
      msg = local.txt('export_ok');
    } else {
      msg = local.txt('export_not_ok');
    }
    return msg;
  }

  Widget buildExportContent(context) {
    List<Widget> childrenList = [buildButtonSave(context), buildButtonSend(context), buildExportReport(context)];
    return Padding(padding: const EdgeInsets.all(12.0), child: Column(children: childrenList));
  }
}
