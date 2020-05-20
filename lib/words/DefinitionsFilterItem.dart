import 'package:attempt/words/WordsBloc.dart';
import 'package:flutter/material.dart';
import 'Resettable.dart';

class DefinitionsFilterItem extends StatefulWidget {
  
  final Function refreshWords;
  DefinitionsFilterItem(this.refreshWords);

  @override
  State<StatefulWidget> createState() {
    return DefinitionsFilterItemState(refreshWords);
  }
}

enum DefinitionsFilterType { HAVE_DEFINITIONS, DO_NOT_HAVE_DEFINITIONS }

class DefinitionsFilterItemStateModel extends Resettable {
  bool selected;
  DefinitionsFilterType filterType;

  DefinitionsFilterItemStateModel() {
    selected = false;
    filterType = DefinitionsFilterType.HAVE_DEFINITIONS;
  }

  void reset() {
    selected = false;
    filterType = DefinitionsFilterType.HAVE_DEFINITIONS;
  }
}

class DefinitionsFilterItemState extends State {

  final model = WordsBloc.definitionsFilterItemStateModel;
  Function refreshWords;
  DefinitionsFilterItemState(this.refreshWords);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        onTap: () {
          setState(() {
            model.selected = !model.selected;
            refreshWords();
          });
        },
        child: Row(
          children: [
            Checkbox(
              value: model.selected,
              onChanged: (value) {
                setState(() {
                  model.selected = value;
                  refreshWords();
                });
              },
            ),
            Text("Definitions:")
          ],
        ),
      ),
      InkWell(
        onTap: () {
          setState(() {
            model.selected = true;
            model.filterType = DefinitionsFilterType.HAVE_DEFINITIONS;
            refreshWords();
          });
        },
        child: Row(children: [
          SizedBox(width: 32),
          Radio(
              value: DefinitionsFilterType.HAVE_DEFINITIONS,
              groupValue: model.filterType,
              onChanged: (newValue) {
                setState(() {
                  model.selected = true;
                  model.filterType = newValue;
                  refreshWords();
                });
              }),
          Expanded(child: const Text('Have'))
        ]),
      ),
      InkWell(
        onTap: () {
          setState(() {
            model.selected = true;
            model.filterType = DefinitionsFilterType.DO_NOT_HAVE_DEFINITIONS;
            refreshWords();
          });
        },
        child: Row(children: [
          SizedBox(width: 32),
          Radio(
              value: DefinitionsFilterType.DO_NOT_HAVE_DEFINITIONS,
              groupValue: model.filterType,
              onChanged: (newValue) {
                setState(() {
                  model.selected = true;
                  model.filterType = newValue;
                  refreshWords();
                });
              }),
          Expanded(child: const Text('Don\'t Have'))
        ]),
      )
    ]);
  }
}