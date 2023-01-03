// ignore: file_names
import 'package:flutter/material.dart';
// ignore: file_names
import 'package:myspoons/donationPage.dart';
// ignore: file_names
import 'package:provider/provider.dart';
// ignore: file_names
import 'model.dart';
import 'intl.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key, required this.title}) : super(key: key);
  final String title;
  static TextStyle textStyle =
      const TextStyle(color: Colors.blueGrey, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    final Localization local =
        Provider.of<Settings>(context, listen: true).local;
    return Scaffold(
        appBar: AppBar(title: Text(local.txt('set_title'))),
        body: buildSettingsContent(context));
  }

  // return a list of DropdownMenuItem from a list of integers
  List<DropdownMenuItem> _listDropdownMenuItemFromList(List<int> list) {
    List<DropdownMenuItem> itemList =
        list.map<DropdownMenuItem<int>>((int value) {
      return DropdownMenuItem<int>(
          value: value,
          child: Text(
            value.toString(),
            style: textStyle,
          ));
    }).toList();
    return itemList;
  }

  buildLanguageSelector(BuildContext context) {
    const lexicon = Localization.lexicon;
    final Settings settings = Provider.of<Settings>(context, listen: true);
    final Localization local = settings.local;
    String selectedValue = local.language;
    final List<String> languages = lexicon.keys.toList();

    return Column(
      children: [
        Row(children: [
          Text("${local.txt('set_language')} : ", style: textStyle),
          DropdownButton(
            value: selectedValue,
            items: languages
                .map<DropdownMenuItem<String>>(
                    (lang) => DropdownMenuItem<String>(
                        value: lang,
                        child: Text(
                          lang,
                          style: textStyle,
                        )))
                .toList(),
            onChanged: (value) {
              selectedValue = settings.updateLanguage(value);
            },
          )
        ])
      ],
    );
  }

  buildMaxSpoonNbSelector(BuildContext context) {
    List<int> list = [8, 10, 12, 14, 16, 18, 20];
    final Localization local =
        Provider.of<Settings>(context, listen: false).local;
    Settings provider = Provider.of<Settings>(context, listen: true);
    int selectedValue = provider.maxSpoonNb;
    bool enableReset = provider.enableMaxSpoonReset;
    TimeOfDay resetTime = provider.resetMaxSpoonTime;

    return Column(children: [
      Row(children: [
        Text("${local.txt('set_max_spoon')} : ", style: textStyle),
        DropdownButton(
            value: selectedValue,
            items: _listDropdownMenuItemFromList(list),
            onChanged: (value) {
              provider.updateMaxSpoonNb(value, enableReset, resetTime);
              selectedValue = value;
            })
      ]),
      Row(children: [
        Switch(
            value: enableReset,
            onChanged: (value) {
              provider.updateMaxSpoonNb(selectedValue, value, resetTime);
              enableReset = value;
            }),
        Text(
          local.txt('set_reset_max'),
          style: textStyle,
        )
      ])
    ]);
  }

  buildAppNotifierSelector(BuildContext context) {
    Settings provider = Provider.of<Settings>(context, listen: true);
    final Localization local =
        Provider.of<Settings>(context, listen: false).local;
    return Row(children: [
      Switch(
        value: provider.enableReminder,
        onChanged: (value) => {
          provider.updateReminder(value, provider.reminderPeriod,
              provider.reminderStart, provider.reminderStop)
        },
      ),
      Text(
        local.txt('set_enable_reminder'),
        style: textStyle,
      ),
    ]);
  }

  Widget buildAppNotifierParameters(BuildContext context) {
    Settings provider = Provider.of<Settings>(context, listen: true);
    final Localization local =
        Provider.of<Settings>(context, listen: false).local;
    bool enabled = provider.enableReminder;
    if (!enabled) {
      return const SizedBox(width: 0, height: 0);
    }
    int period = provider.reminderPeriod;
    TimeOfDay notifierStart = provider.reminderStart;
    TimeOfDay notifierStop = provider.reminderStop;
    final localizations = MaterialLocalizations.of(context);
    final formattedStart = localizations.formatTimeOfDay(notifierStart,
        alwaysUse24HourFormat: true);
    final formattedStop = localizations.formatTimeOfDay(notifierStop,
        alwaysUse24HourFormat: true);

    List<int> list = [1, 2, 3, 4, 5, 6, 7, 8];
    return Column(
      children: [
        Row(children: [
          Text("${local.txt('set_remind_every')} ", style: textStyle),
          DropdownButton(
              items: _listDropdownMenuItemFromList(list),
              value: period,
              onChanged: (value) {
                provider.updateReminder(
                    enabled, value, notifierStart, notifierStop);
              }),
          Text(" ${local.txt('set_hours')}", style: textStyle),
        ]),
        Row(children: [
          Text(
            "        ${local.txt('set_from')}",
            style: textStyle,
          ),
          TextButton(
            child: Text(formattedStart),
            onPressed: () async {
              TimeOfDay? startHour = await showTimePicker(
                  context: context, initialTime: notifierStart);
              notifierStart = startHour ?? notifierStart;
              provider.updateReminder(
                  enabled, period, notifierStart, notifierStop);
            },
          ),
          Text(
            " ${local.txt('set_to')}",
            style: textStyle,
          ),
          TextButton(
            child: Text(formattedStop),
            onPressed: () async {
              TimeOfDay? stopHour = await showTimePicker(
                  context: context, initialTime: notifierStop);
              notifierStop = stopHour ?? notifierStop;
              provider.updateReminder(
                  enabled, period, notifierStart, notifierStop);
            },
          ),
          Text(local.txt('set_daily'), style: textStyle)
        ])
      ],
    );
  }

  Widget buildFileResetButton(BuildContext context) {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    SpoonTracker provider = Provider.of<SpoonTracker>(context, listen: false);
    final Localization local =
        Provider.of<Settings>(context, listen: false).local;
    Widget resetButton = TextButton(
        child: Text(local.txt('set_reset_file')),
        onPressed: () async {
          var confirmed = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => AlertDialog(
                          title: Text(local.txt('set_confirm_title')),
                          content: Text(local.txt('set_confirm_body')),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(local.txt('set_confirm_cancel'))),
                            TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(local.txt('set_confirm_ok')))
                          ])) ??
              false;
          if (confirmed) {
            provider.deleteFile();
            scaffoldMessenger.showSnackBar(SnackBar(
                content: Text(local.txt('set_snackbar')),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.blueAccent));
          }
        });
    return resetButton;
  }

  Widget buildDonationPageButton(BuildContext context) {
    final Localization local =
        Provider.of<Settings>(context, listen: false).local;
    Widget donationPageButton = TextButton(
      child: Text(local.txt('set_donation_button')),
      onPressed: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DonationPage(title: local.txt('donation_title'));
        }))
      },
    );
    return donationPageButton;
  }

  buildSettingsContent(BuildContext context) {
    List<Widget> childrenList = [
      buildLanguageSelector(context),
      buildMaxSpoonNbSelector(context),
      buildAppNotifierSelector(context),
      buildAppNotifierParameters(context),
      buildDonationPageButton(context),
      buildFileResetButton(context)
    ];
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: childrenList));
  }
}
