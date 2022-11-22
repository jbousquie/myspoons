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

  // return a list of DropdownMenuItem from a list of integers
  List<DropdownMenuItem> _listDropdownMenuItemFromList(List<int> list) {
    List<DropdownMenuItem> itemList =
        list.map<DropdownMenuItem<int>>((int value) {
      return DropdownMenuItem<int>(value: value, child: Text(value.toString()));
    }).toList();
    return itemList;
  }

  buildMaxSpoonNbSelector(context) {
    List<int> list = [8, 10, 12, 14, 16];
    int maxSpoonNb = Provider.of<Settings>(context, listen: false).maxSpoonNb;
    return Row(children: [
      const Text('Maximum spoon number'),
      DropdownButton(
          value: maxSpoonNb,
          items: _listDropdownMenuItemFromList(list),
          onChanged: ((value) {
            Provider.of<Settings>(context, listen: false)
                .updateMaxSpoonNb(value);
          }))
    ]);
  }

  buildAppNotifierSelector(context) {
    return Row(children: [
      const Text('Enable reminder'),
      Switch(
        value: false,
        onChanged: (value) => {},
      )
    ]);
  }

  buildAppNotifierParameters(context) {
    List<int> list = [1, 2, 3, 4];
    return Column(
      children: [
        Row(
          children: [
            const Text('Remind me every '),
            DropdownButton(
                items: _listDropdownMenuItemFromList(list),
                onChanged: ((value) => {}))
          ],
        )
      ],
    );
  }

  buildSettingsContent(context) {
    List<Widget> childrenList = [
      buildMaxSpoonNbSelector(context),
      buildAppNotifierSelector(context)
    ];
    return Column(children: childrenList);
  }
}
