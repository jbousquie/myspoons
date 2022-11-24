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

  void _updateNotifier(BuildContext context, bool enabled, int period) {
    Settings provider = Provider.of<Settings>(context, listen: false);
    provider.enableReminder = enabled;
    provider.reminderPeriod = period;
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
    bool enabled = provider.enableReminder;
    int period = provider.reminderPeriod;
    return Row(children: [
      const Text('Enable reminder'),
      Switch(
        value: enabled,
        onChanged: (value) => {_updateNotifier(context, value, period)},
      )
    ]);
  }

  buildAppNotifierParameters(BuildContext context) {
    Settings provider = Provider.of<Settings>(context, listen: false);
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
        Row(
          children: [
            const Text('Remind me every '),
            DropdownButton(
                items: _listDropdownMenuItemFromList(list),
                value: period,
                onChanged: (value) => {_updateNotifier(context, enabled, value)}),
            const Text(' hour(s) from '),
            Text(formattedStart),
            const Text(' to '),
            Text(formattedStop)
          ],
        )
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
