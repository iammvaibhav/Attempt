import 'package:attempt/sentences/SentencesBloc.dart';
import 'package:attempt/words/DateFilterItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'AddedSentencesFilterItem.dart';
import 'CategoryFilterItem.dart';
import 'SentencesEvent.dart';

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
              child: DateFilterItem(() { BlocProvider.of<SentencesBloc>(context).add(FilterSentencesEvent()); }, SentencesBloc.dateFilterItemStateModel)),
          DropdownMenuItem(
              value: "AddedSentencesFilter",
              child: AddedSentencesFilterItem(() { BlocProvider.of<SentencesBloc>(context).add(FilterSentencesEvent()); }, SentencesBloc.addedSentencesFilterItemStateModel)),
          DropdownMenuItem(
              value: "CategoryFilter",
              child: CategoryFilterItem(() { BlocProvider.of<SentencesBloc>(context).add(FilterSentencesEvent()); }, SentencesBloc.categoryFilterItemStateModel)),
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
