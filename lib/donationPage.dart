// ignore: file_names
import 'package:flutter/gestures.dart';
// ignore: file_names
import 'package:flutter/material.dart';
// ignore: file_names
import 'package:url_launcher/url_launcher.dart';
import 'intl.dart';
// ignore: file_names
import 'package:provider/provider.dart';
// ignore: file_names
import 'model.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({Key? key, required this.title}) : super(key: key);
  final String title;
  static TextStyle textStyle =
      const TextStyle(color: Colors.blueGrey, fontSize: 16);
  static TextStyle linkStyle = const TextStyle(
      color: Colors.blueAccent, fontStyle: FontStyle.italic, fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final Localization local =
        Provider.of<Settings>(context, listen: false).local;
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Padding(
            padding: const EdgeInsets.all(25),
            child: RichText(
                text: TextSpan(
                    text: local.txt('donation_text'),
                    style: textStyle,
                    children: [
                  TextSpan(
                      text: local.txt('donation_spoon_theory'),
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final String url = local.txt('theory_link');
                          final Uri uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        }),
                  TextSpan(text: local.txt('credits'), children: [
                    TextSpan(
                        text: 'Github\n\n',
                        style: linkStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final String url = local.txt('github_link');
                            final Uri uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          })
                  ]),
                  TextSpan(
                      text: "${local.txt('set_documentation')}\n\n",
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final String url = local.txt('documentation_link');
                          final Uri uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        }),
                  TextSpan(
                      text: local.txt('bug_report'),
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final String url = local.txt('report_link');
                          final Uri uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        }),
                  TextSpan(
                      text: local.txt('donation_support'),
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final String url = local.txt('support_link');
                          final Uri uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        }),
                ]))));
  }
}
