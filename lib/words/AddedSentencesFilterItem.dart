import 'package:attempt/words/Resettable.dart';
import 'package:attempt/words/WordsBloc.dart';
import 'package:flutter/material.dart';

class AddedSentencesFilterItem extends StatefulWidget {
  
  final Function refreshWords;
  AddedSentencesFilterItem(this.refreshWords);

  @override
  State<StatefulWidget> createState() {
    return AddedSentencesFilterItemState(refreshWords);
  }
}

enum AddedSentencesFilterType {
  HAVE_ADDED_SENTENCES,
  DO_NOT_HAVE_ADDED_SENTENCES
}

class AddedSentencesFilterItemStateModel extends Resettable {
  bool selected;
  AddedSentencesFilterType filterType;

  AddedSentencesFilterItemStateModel() {
    selected = false;
    filterType = AddedSentencesFilterType.HAVE_ADDED_SENTENCES;
  }

  void reset() {
    selected = false;
    filterType = AddedSentencesFilterType.HAVE_ADDED_SENTENCES;
  }
}

class AddedSentencesFilterItemState extends State {
  
  final model = WordsBloc.addedSentencesFilterItemStateModel;
  Function refreshWords;
  
  AddedSentencesFilterItemState(this.refreshWords);

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
            Expanded(child: Text("Added Sentences:"))
          ],
        ),
      ),
      InkWell(
        onTap: () {
          setState(() {
            model.selected = true;
            model.filterType = AddedSentencesFilterType.HAVE_ADDED_SENTENCES;
            refreshWords();
          });
        },
        child: Row(children: [
          SizedBox(width: 32),
          Radio(
              value: AddedSentencesFilterType.HAVE_ADDED_SENTENCES,
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
            model.filterType = AddedSentencesFilterType.DO_NOT_HAVE_ADDED_SENTENCES;
            refreshWords();
          });
        },
        child: Row(children: [
          SizedBox(width: 32),
          Radio(
              value: AddedSentencesFilterType
                  .DO_NOT_HAVE_ADDED_SENTENCES,
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
