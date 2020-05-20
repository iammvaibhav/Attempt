import 'package:attempt/words/Resettable.dart';
import 'package:flutter/material.dart';

class AddedSentencesFilterItem extends StatefulWidget {

  final Function refreshWords;
  final AddedSentencesFilterItemStateModel model;
  AddedSentencesFilterItem(this.refreshWords, this.model);

  @override
  State<StatefulWidget> createState() {
    return AddedSentencesFilterItemState(refreshWords, model);
  }
}

class AddedSentencesFilterItemStateModel extends Resettable {
  bool selected;
  bool contextualSentences;
  bool nonContextualSentences;

  AddedSentencesFilterItemStateModel() {
    selected = false;
    contextualSentences = true;
    nonContextualSentences = true;
  }

  void reset() {
    selected = false;
    contextualSentences = true;
    nonContextualSentences = true;
  }
}

class AddedSentencesFilterItemState extends State {

  Function refreshWords;
  final AddedSentencesFilterItemStateModel model;
  AddedSentencesFilterItemState(this.refreshWords, this.model);

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
            model.contextualSentences = !model.contextualSentences;
            refreshWords();
          });
        },
        child: Row(children: [
          SizedBox(width: 32),
          Checkbox(
              value: model.contextualSentences,
              onChanged: (newValue) {
                setState(() {
                  model.selected = true;
                  model.contextualSentences = newValue;
                  refreshWords();
                });
              }),
          Expanded(child: const Text('Contextual'))
        ]),
      ),
      InkWell(
        onTap: () {
          setState(() {
            model.selected = true;
            model.nonContextualSentences = !model.nonContextualSentences;
            refreshWords();
          });
        },
        child: Row(children: [
          SizedBox(width: 32),
          Checkbox(
              value: model.nonContextualSentences,
              onChanged: (newValue) {
                setState(() {
                  model.selected = true;
                  model.nonContextualSentences = newValue;
                  refreshWords();
                });
              }),
          Expanded(child: const Text('Non Contextual'))
        ]),
      )
    ]);
  }
}
