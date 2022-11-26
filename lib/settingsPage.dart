// ignore: file_names
import 'package:flutter/material.dart';
// ignore: file_names
import 'package:provider/provider.dart';
// ignore: file_names
import 'model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(title: Text(title)),
            body: buildSettingsContent(context)),
        //On leaving the Settings page
        onWillPop: () async {
          Provider.of<Settings>(context, listen: false)
              .localNotificationService
              .showScheduledNotification(
                  id: 0, title: 'test sche', body: "Coucou", seconds: 4);
          Provider.of<Settings>(context, listen: false).storeSettings();
          Navigator.of(context).pop();
          return true;
        });
  }

  void _updateMaxSpoonNb(BuildContext context, int value) {
    Provider.of<Settings>(context, listen: false).updateMaxSpoonNb(value);
  }

  // return a list of DropdownMenuItem from a list of integers
  List<DropdownMenuItem> _listDropdownMenuItemFromList(List<int> list) {
    List<DropdownMenuItem> itemList =
        list.map<DropdownMenuItem<int>>((int value) {
      return DropdownMenuItem<int>(value: value, child: Text(value.toString()));
    }).toList();
    return itemList;
  }

  buildMaxSpoonNbSelector(BuildContext context) {
    List<int> list = [8, 10, 12, 14, 16];
    int selectedValue = Provider.of<Settings>(context, listen: true).maxSpoonNb;
    return Row(children: [
      Text('Maximum spoon number :  < $selectedValue > '),
      DropdownButton(
          value: selectedValue,
          items: _listDropdownMenuItemFromList(list),
          onChanged: (value) {
            _updateMaxSpoonNb(context, value);
            selectedValue = value;
          })
    ]);
  }

  buildAppNotifierSelector(BuildContext context) {
    Settings provider = Provider.of<Settings>(context, listen: true);
    return Row(children: [
      const Text('Enable reminder'),
      Switch(
        value: provider.enableReminder,
        onChanged: (value) => {
          provider.updateReminder(value, provider.reminderPeriod,
              provider.reminderStart, provider.reminderStop)
        },
      )
    ]);
  }

  buildAppNotifierParameters(BuildContext context) {
    Settings provider = Provider.of<Settings>(context, listen: true);
    bool enabled = provider.enableReminder;
    int period = provider.reminderPeriod;
    TimeOfDay notifierStart = provider.reminderStart;
    TimeOfDay notifierStop = provider.reminderStop;
    final localizations = MaterialLocalizations.of(context);
    final formattedStart = localizations.formatTimeOfDay(notifierStart);
    final formattedStop = localizations.formatTimeOfDay(notifierStop);

    List<int> list = [1, 2, 3, 4];
    return Column(
      children: [
        Row(children: [
          const Text('Remind me every '),
          DropdownButton(
              items: _listDropdownMenuItemFromList(list),
              value: period,
              onChanged: (value) {
                provider.updateReminder(
                    enabled, value, notifierStart, notifierStop);
              }),
          const Text(' hour(s)'),
        ]),
        Row(children: [
          const Text('from '),
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
          const Text(' to '),
          TextButton(
            child: Text(formattedStop),
            onPressed: () async {
              TimeOfDay? stopHour = await showTimePicker(
                  context: context, initialTime: notifierStop);
              notifierStop = stopHour ?? notifierStop;
              provider.updateReminder(
                  enabled, period, notifierStart, notifierStop);
            },
          )
        ])
      ],
    );
  }

  buildSettingsContent(BuildContext context) {
    List<Widget> childrenList = [
      buildMaxSpoonNbSelector(context),
      buildAppNotifierSelector(context),
      buildAppNotifierParameters(context)
    ];
    return Column(children: childrenList);
  }
}
