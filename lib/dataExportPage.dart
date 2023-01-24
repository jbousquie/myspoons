// ignore: file_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';
import 'package:provider/provider.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:myspoons/model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:language_picker/language_picker.dart';
import 'intl.dart';

class DataExportPage extends StatelessWidget {
  const DataExportPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    final Localization local =
        Provider.of<Settings>(context, listen: true).local;
    return Scaffold(
        appBar: AppBar(title: Text(local.txt('chartsmenu_export'))),
        body: buildExportContent(context));
  }

  Widget buildButtonSave(BuildContext context) {
    final Localization local =
        Provider.of<Settings>(context, listen: true).local;
    final Text saveText = Text(local.txt('export_savetext'));
    final TextButton buttonSave = TextButton(
      child: Text(local.txt('button_save')),
      onPressed: () {
        _saveFile(context);
      },
    );
    final Column col = Column(children: [saveText, buttonSave]);
    final Container cont = Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0), child: col);
    return cont;
  }

  Widget buildButtonSend(BuildContext context) {
    final Localization local =
        Provider.of<Settings>(context, listen: true).local;
    final SpoonTracker provider =
        Provider.of<SpoonTracker>(context, listen: true);
    final sendText = Text(local.txt('export_sendtext'));
    final TextButton buttonSave = TextButton(
      child: Text(local.txt('button_send')),
      onPressed: () async {
        String msg = await _sendFile(context);
        provider.exportReport = msg;
      },
    );
    final Column col = Column(
      children: [
        sendText,
        buildSendDataSelectors(context),
        buttonSave,
      ],
    );
    final Container cont = Container(
      margin: const EdgeInsets.symmetric(vertical: 30.0),
      child: col,
    );
    return cont;
  }

  List<DropdownMenuItem> yearList() {
    final int yearNow = DateTime.now().year;
    final int start = yearNow - 8;
    final int end = yearNow - 70;
    List<DropdownMenuItem> itemList = [];
    for (var i = start; i > end; i--) {
      itemList.add(
          DropdownMenuItem(value: i.toString(), child: Text(i.toString())));
    }
    return itemList;
  }

  Widget languageItemRow(Language language) {
    return Text(language.name);
  }

  Widget buildSendDataSelectors(BuildContext context) {
    final Settings settings = Provider.of<Settings>(context, listen: true);
    final local = settings.local;
    final String lg = local.language;
    final String isoCode = settings.usedLg;
    final Language usedLanguage = Language.fromIsoCode(isoCode);
    final Language usrLanguage =
        (lg == 'fr' && lg == 'en') ? Languages.french : usedLanguage;
    final birthYear = settings.birthYear;
    final gender = settings.gender;

    final Row rowBirth = Row(children: [
      Text(local.txt('export_birth')),
      DropdownButton(
          value: birthYear,
          items: yearList(),
          onChanged: (val) => {settings.birthYear = val})
    ]);
    final Row rowGender = Row(children: [
      Text(
        local.txt('export_gender'),
      ),
      DropdownButton(
        value: gender,
        items: const [
          DropdownMenuItem(value: 'F', child: Text('F')),
          DropdownMenuItem(value: 'M', child: Text('M')),
          DropdownMenuItem(value: 'N', child: Text('N')),
        ],
        onChanged: (value) => {settings.gender = value ?? 'F'},
      )
    ]);
    final Row rowLang = Row(
      children: [
        Text(local.txt('export_lang')),
        SizedBox(
            height: 20,
            width: 150,
            child: LanguagePickerDropdown(
              initialValue: usrLanguage,
              itemBuilder: languageItemRow,
              onValuePicked: (value) => {settings.usedLg = value.isoCode},
            ))
      ],
    );
    final Column col = Column(
      children: [rowBirth, rowGender, rowLang],
    );
    return col;
  }

  Widget buildExportReport(BuildContext context) {
    final SpoonTracker provider =
        Provider.of<SpoonTracker>(context, listen: false);
    final String msg = provider.exportReport;
    final Text reportMsg = Text(msg);
    return reportMsg;
  }

  void _saveFile(BuildContext context) async {
    final SpoonTracker provider =
        Provider.of<SpoonTracker>(context, listen: false);
    final String path = await provider.filePath;
    final params = SaveFileDialogParams(sourceFilePath: path);
    await FlutterFileDialog.saveFile(params: params);
  }

  Future<String> _sendFile(BuildContext context) async {
    final SpoonTracker provider =
        Provider.of<SpoonTracker>(context, listen: false);
    final Settings settings = Provider.of<Settings>(context, listen: false);
    final Localization local = settings.local;
    final String data = await provider.getDataFromFile();
    final String url = provider.collectURL;
    final uri = Uri.parse(url);
    final request = http.MultipartRequest('POST', uri);
    request.fields['uuid'] = await provider.uuid;
    request.fields['gender'] = settings.gender;
    request.fields['birth'] = settings.birthYear;
    request.fields['lang'] = settings.birthYear;
    request.files.add(http.MultipartFile.fromString('data', data,
        contentType: MediaType('text', 'csv'), filename: 'myspoons.csv'));
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
    List<Widget> childrenList = [
      buildButtonSave(context),
      buildButtonSend(context),
      buildExportReport(context)
    ];

    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: childrenList));
  }
}
