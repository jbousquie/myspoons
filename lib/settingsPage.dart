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
        child: Scaffold(appBar: AppBar(title: Text(title)), body: buildSettingsContent(context)),
        //On leaving the Settings page
        onWillPop: () async {
          Provider.of<Settings>(context, listen: false)
              .localNotificationService
              .showScheduledNotification(id: 0, title: 'test sche', body: "Coucou", seconds: 4);
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
    List<DropdownMenuItem> itemList = list.map<DropdownMenuItem<int>>((int value) {
      return DropdownMenuItem<int>(value: value, child: Text(value.toString()));
    }).toList();
    return itemList;
  }

  buildMaxSpoonNbSelector(BuildContext context, selectedValue) {
    List<int> list = [8, 10, 12, 14, 16];
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
    Settings provider = Provider.of<Settings>(context, listen: false);
    return Row(children: [
      const Text('Enable reminder'),
      Switch(
        value: provider.enableReminder,
        onChanged: (value) =>
            {provider.updateReminder(value, provider.reminderPeriod, provider.reminderStart, provider.reminderStop)},
      )
    ]);
  }

  buildAppNotifierParameters(BuildContext context) {
    Settings provider = Provider.of<Settings>(context, listen: false);
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
              value: provider.reminderPeriod,
              onChanged: (value) {
                provider.updateReminder(provider.enableReminder, value, provider.reminderStart, provider.reminderStop);
              }),
          const Text(' hour(s)'),
        ]),
        Row(children: [
          const Text('from '),
          TextButton(
            child: Text(formattedStart),
            onPressed: () async {
              TimeOfDay? startHour = await showTimePicker(context: context, initialTime: provider.reminderStart);
              notifierStart = startHour ?? provider.reminderStart;
              provider.updateReminder(
                  provider.enableReminder, provider.reminderPeriod, provider.reminderStart, provider.reminderStop);
            },
          ),
          const Text(' to '),
          TextButton(
            child: Text(formattedStop),
            onPressed: () async {
              TimeOfDay? stopHour = await showTimePicker(context: context, initialTime: provider.reminderStop);
              notifierStop = stopHour ?? provider.reminderStop;
              provider.updateReminder(
                  provider.enableReminder, provider.reminderPeriod, provider.reminderStart, provider.reminderStop);
            },
          )
        ])
      ],
    );
  }

  buildSettingsContent(BuildContext context) {
    int maxSpoonNb = Provider.of<Settings>(context, listen: false).maxSpoonNb;
    List<Widget> childrenList = [
      buildMaxSpoonNbSelector(context, maxSpoonNb),
      buildAppNotifierSelector(context),
      buildAppNotifierParameters(context)
    ];
    return Column(children: childrenList);
  }
}
