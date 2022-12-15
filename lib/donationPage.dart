// ignore: file_names
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'intl.dart';
// ignore: file_names
import 'package:provider/provider.dart';
// ignore: file_names
import 'model.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({Key? key, required this.title}) : super(key: key);
  final String title;
  static TextStyle textStyle = const TextStyle(color: Colors.blueGrey, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    final Localization local = Provider.of<Settings>(context, listen: false).local;
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Padding(
            padding: const EdgeInsets.all(25),
            child: RichText(
                text: TextSpan(text: local.txt('donation_text'), style: textStyle, children: [
              TextSpan(
                  text: local.txt('theory_link'),
                  style: const TextStyle(color: Colors.blueAccent, fontStyle: FontStyle.italic),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final String url = local.txt('theory_link');
                      if (await canLaunchUrlString(url)) {
                        await launchUrlString(url);
                      }
                    })
            ]))));
  }
}
