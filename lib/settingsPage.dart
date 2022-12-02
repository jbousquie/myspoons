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
    return Scaffold(appBar: AppBar(title: Text(title)), body: buildSettingsContent(context));
  }

  // return a list of DropdownMenuItem from a list of integers
  List<DropdownMenuItem> _listDropdownMenuItemFromList(List<int> list) {
    List<DropdownMenuItem> itemList = list.map<DropdownMenuItem<int>>((int value) {
      return DropdownMenuItem<int>(value: value, child: Text(value.toString()));
    }).toList();
    return itemList;
  }

  buildMaxSpoonNbSelector(BuildContext context) {
    List<int> list = [8, 10, 12, 14, 16, 18, 20];
    Settings provider = Provider.of<Settings>(context, listen: true);
    int selectedValue = provider.maxSpoonNb;
    bool enableReset = provider.enableMaxSpoonReset;
    TimeOfDay resetTime = provider.resetMaxSpoonTime;

    return Column(children: [
      Row(children: [
        const Text('Maximum spoon number : '),
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
        const Text('Daily reset the initial spoon\nnumber to its maximum value')
      ])
    ]);
  }

  buildAppNotifierSelector(BuildContext context) {
    Settings provider = Provider.of<Settings>(context, listen: true);
    return Row(children: [
      Switch(
        value: provider.enableReminder,
        onChanged: (value) =>
            {provider.updateReminder(value, provider.reminderPeriod, provider.reminderStart, provider.reminderStop)},
      ),
      const Text('Enable reminder'),
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
    final formattedStart = localizations.formatTimeOfDay(notifierStart, alwaysUse24HourFormat: true);
    final formattedStop = localizations.formatTimeOfDay(notifierStop, alwaysUse24HourFormat: true);

    List<int> list = [1, 2, 3, 4, 5, 6, 7, 8];
    return Column(
      children: [
        Row(children: [
          const Text('Remind me for a week every '),
          DropdownButton(
              items: _listDropdownMenuItemFromList(list),
              value: period,
              onChanged: (value) {
                provider.updateReminder(enabled, value, notifierStart, notifierStop);
              }),
          const Text(' hour(s)'),
        ]),
        Row(children: [
          const Text('        from'),
          TextButton(
            child: Text(formattedStart),
            onPressed: () async {
              TimeOfDay? startHour = await showTimePicker(context: context, initialTime: notifierStart);
              notifierStart = startHour ?? notifierStart;
              provider.updateReminder(enabled, period, notifierStart, notifierStop);
            },
          ),
          const Text(' to'),
          TextButton(
            child: Text(formattedStop),
            onPressed: () async {
              TimeOfDay? stopHour = await showTimePicker(context: context, initialTime: notifierStop);
              notifierStop = stopHour ?? notifierStop;
              provider.updateReminder(enabled, period, notifierStart, notifierStop);
            },
          ),
          const Text('daily')
        ])
      ],
    );
  }

  Widget buildFileResetButton(BuildContext context) {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    SpoonTracker provider = Provider.of<SpoonTracker>(context, listen: false);
    Widget resetButton = TextButton(
        child: const Text('Reset data file'),
        onPressed: () async {
          var confirmed = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => AlertDialog(
                          title: const Text('Warning'),
                          content: const Text(
                              'This reset will erase all the data collected until now.\n\nDo you confirm this action ?'),
                          actions: <Widget>[
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('OK'))
                          ])) ??
              false;
          if (confirmed) {
            provider.deleteFile();
            scaffoldMessenger.showSnackBar(const SnackBar(
                content: Text("Data file deleted"),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.blueAccent));
          }
        });
    return resetButton;
  }

  buildSettingsContent(BuildContext context) {
    List<Widget> childrenList = [
      buildMaxSpoonNbSelector(context),
      buildAppNotifierSelector(context),
      buildAppNotifierParameters(context),
      buildFileResetButton(context)
    ];
    return Padding(padding: const EdgeInsets.all(12.0), child: Column(children: childrenList));
  }
}
