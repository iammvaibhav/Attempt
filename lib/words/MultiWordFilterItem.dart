import 'package:attempt/words/Resettable.dart';
import 'package:attempt/words/WordsBloc.dart';
import 'package:flutter/material.dart';

class MultiWordFilterItem extends StatefulWidget {

  final Function refreshWords;
  MultiWordFilterItem(this.refreshWords);

  @override
  State<StatefulWidget> createState() {
    return MultiWordFilterItemState(refreshWords);
  }
}

enum MultiWordFilterType {
  HAVE_MULTI_WORDS,
  DO_NOT_HAVE_MULTI_WORDS
}

class MultiWordFilterItemStateModel extends Resettable{
  bool selected;
  MultiWordFilterType filterType;

  MultiWordFilterItemStateModel() {
    selected = false;
    filterType = MultiWordFilterType.HAVE_MULTI_WORDS;
  }

  void reset() {
    selected = false;
    filterType = MultiWordFilterType.HAVE_MULTI_WORDS;
  }
}

class MultiWordFilterItemState extends State {

  final model = WordsBloc.multiWordFilterItemStateModel;
  Function refreshWords;
  MultiWordFilterItemState(this.refreshWords);

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
            Expanded(child: Text("Multi Words:"))
          ],
        ),
      ),
      InkWell(
        onTap: () {
          setState(() {
            model.selected = true;
            model.filterType = MultiWordFilterType.HAVE_MULTI_WORDS;
            refreshWords();
          });
        },
        child: Row(children: [
          SizedBox(width: 32),
          Radio(
              value: MultiWordFilterType.HAVE_MULTI_WORDS,
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
            model.filterType = MultiWordFilterType.DO_NOT_HAVE_MULTI_WORDS;
            refreshWords();
          });
        },
        child: Row(children: [
          SizedBox(width: 32),
          Radio(
              value: MultiWordFilterType
                  .DO_NOT_HAVE_MULTI_WORDS,
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
