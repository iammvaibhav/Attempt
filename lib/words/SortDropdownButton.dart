import 'package:attempt/words/Resettable.dart';
import 'package:attempt/words/WordsBloc.dart';
import 'package:attempt/words/WordsEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortDropdownButton extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SortDropdownButtonState();
  }
}

class SortDropdownButtonStateModel extends Resettable {
  String currValue;
  Map<String, bool> sortOrder;

  SortDropdownButtonStateModel() {
    currValue = "Chronological";
    sortOrder = {
      "Chronological": true,
      "Alphabetical": false,
      "Hit Count": true,
      "Word Length": true,
    };
  }

  void reset() {
    currValue = "Chronological";
    sortOrder["Chronological"] = true;
    sortOrder["Alphabetical"] = false;
    sortOrder["Hit Count"] = true;
    sortOrder["Word Length"] = true;
  }
}

class SortDropdownButtonState extends State {

  final model = WordsBloc.sortStateModel;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: model.currValue,
        items: [
          "Chronological",
          "Alphabetical",
          "Hit Count",
          "Word Length",
          "Random"
        ].map((e) {
          if (e != "Random")
            return DropdownMenuItem(
                value: e,
                child: SortItem(e, model.sortOrder, (value) {
                  setState(() {
                    model.currValue = value;
                    WordsBloc.preserveScrollPosition = false;
                    BlocProvider.of<WordsBloc>(context).add(RefreshWordsEvent());
                  });
                }));
          else
            return DropdownMenuItem(
                value: e, child: Row(children: [SizedBox(width: 50), Text(e)]));
        }).toList(),
        onChanged: (value) {
          setState(() {
            model.currValue = value;
            WordsBloc.preserveScrollPosition = false;
            BlocProvider.of<WordsBloc>(context).add(RefreshWordsEvent());
          });
        },
        hint: Text('Select value'),
      ),
    );
  }
}

class SortItem extends StatefulWidget {
  final String value;
  final Map<String, bool> sortOrder;
  final Function rebuild;

  SortItem(this.value, this.sortOrder, this.rebuild);

  @override
  State<StatefulWidget> createState() {
    return SortItemState(value, sortOrder, rebuild);
  }
}

class SortItemState extends State {
  String value;
  Map<String, bool> sortOrder;
  Function rebuild;

  SortItemState(this.value, this.sortOrder, this.rebuild);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(
        icon: Icon(
          sortOrder[value] ? Icons.arrow_upward : Icons.arrow_downward,
          color: Colors.black,
        ),
        padding: EdgeInsets.only(bottom: 1),
        onPressed: () {
          setState(() {
            sortOrder[value] = !sortOrder[value];
            rebuild(value);
          });
        },
      ),
      Text(value)
    ]);
  }
}