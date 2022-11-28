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
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: buildSettingsContent(context));
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
    List<int> list = [8, 10, 12, 14, 16, 18, 20];
    int selectedValue = Provider.of<Settings>(context, listen: true).maxSpoonNb;
    return Row(children: [
      const Text('Maximum spoon number : '),
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

  Widget buildAppNotifierParameters(BuildContext context) {
    Settings provider = Provider.of<Settings>(context, listen: true);
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
          const Text('Remind me for a week every '),
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
          const Text('from'),
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
          const Text(' to'),
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
          const Text('daily')
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
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: childrenList));
  }
}
