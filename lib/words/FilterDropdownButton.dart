import 'package:attempt/words/WordsBloc.dart';
import 'package:attempt/words/WordsEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'AddedSentencesFilterItem.dart';
import 'DateFilterItem.dart';
import 'DefinitionsFilterItem.dart';
import 'DownloadedSentencesFilterItem.dart';
import 'MultiWordFilterItem.dart';

class FilterDropdownButton extends StatefulWidget {
  @override
  State createState() {
    return FilterDropdownButtonState();
  }
}

class FilterDropdownButtonState extends State {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        isExpanded: true,
        value: null,
        items: [
          DropdownMenuItem(
              value: "DateFilter",
              child: DateFilterItem(() { BlocProvider.of<WordsBloc>(context).add(RefreshWordsEvent()); }, WordsBloc.dateFilterModel)),
          DropdownMenuItem(
              value: "MultiWordFilter",
              child: MultiWordFilterItem(() { BlocProvider.of<WordsBloc>(context).add(RefreshWordsEvent()); })),
          DropdownMenuItem(
              value: "DefinitionsFilter",
              child: DefinitionsFilterItem(() { BlocProvider.of<WordsBloc>(context).add(RefreshWordsEvent()); })),
          DropdownMenuItem(
              value: "AddedSentencesFilter",
              child: AddedSentencesFilterItem(() { BlocProvider.of<WordsBloc>(context).add(RefreshWordsEvent()); })),
          DropdownMenuItem(
              value: "DownloadedSentencesFilter",
              child: DownloadedSentencesFilterItem(() { BlocProvider.of<WordsBloc>(context).add(RefreshWordsEvent()); }))
        ],
        onChanged: (value) {
          print(value);
        },
        hint: Text(
          'Apply Filter',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
