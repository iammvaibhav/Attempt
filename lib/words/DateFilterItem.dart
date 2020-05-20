import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

import 'Resettable.dart';

class DateFilterItem extends StatefulWidget {

  final Function refreshWords;
  final DateFilterItemStateModel model;
  DateFilterItem(this.refreshWords, this.model);

  @override
  State<StatefulWidget> createState() {
    return DateFilterItemState(refreshWords, model);
  }
}

enum DateFilterType { CONVENIENT, MANUAL }

class DateFilterItemStateModel extends Resettable {
  bool selected;
  DateFilterType filterType;
  String convenientValue;
  List<DateTime> picked;
  final dateFormat = DateFormat('d MMM, yy');

  DateFilterItemStateModel() {
    selected = false;
    filterType = DateFilterType.CONVENIENT;
    convenientValue = "Today";
    picked = [];
  }

  void reset() {
    selected = false;
    filterType = DateFilterType.CONVENIENT;
    convenientValue = "Today";
    picked = [];
  }
}

class DateFilterItemState extends State {

  final DateFilterItemStateModel model;
  Function refreshWords;
  DateFilterItemState(this.refreshWords, this.model);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              Expanded(child: Text("Date:"))
            ],
          ),
        ),
        Row(
          children: [
            SizedBox(width: 32),
            Radio(
              value: DateFilterType.CONVENIENT,
              groupValue: model.filterType,
              onChanged: (value) {
                setState(() {
                  model.selected = true;
                  model.filterType = value;
                  refreshWords();
                });
              },
            ),
            DropdownButton(
              value: model.convenientValue,
              items: [
                "Today",
                "Last 24 Hours",
                "Yesterday",
                "Last 3 Days",
                "Last Week",
                "Last Month"
              ]
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  model.selected = true;
                  model.convenientValue = newValue;
                  model.filterType = DateFilterType.CONVENIENT;
                  refreshWords();
                });
              },
            )
          ],
        ),
        Row(
          children: [
            SizedBox(width: 32),
            Radio(
              value: DateFilterType.MANUAL,
              groupValue: model.filterType,
              onChanged: (value) async {
                if (model.picked.isEmpty) {
                  final List<DateTime> picked =
                  await DateRagePicker.showDatePicker(
                      context: context,
                      initialFirstDate: new DateTime.now(),
                      initialLastDate:
                      (new DateTime.now()).add(new Duration(days: 7)),
                      firstDate: new DateTime(2020),
                      lastDate: new DateTime(2030));
                  if (picked != null && picked.length == 2) {
                    setState(() {
                      model.selected = true;
                      model.picked = picked;
                      model.filterType = DateFilterType.MANUAL;
                      refreshWords();
                    });
                  }
                } else {
                  setState(() {
                    model.selected = true;
                    model.filterType = value;
                    refreshWords();
                  });
                }
              },
            ),
            Expanded(
              child: GestureDetector(onTap: () async {
                final List<DateTime> picked =
                await DateRagePicker.showDatePicker(
                    context: context,
                    initialFirstDate: new DateTime.now(),
                    initialLastDate:
                    (new DateTime.now()).add(new Duration(days: 7)),
                    firstDate: new DateTime(2020),
                    lastDate: new DateTime(2030));
                if (picked != null && picked.length == 2) {
                  setState(() {
                    model.selected = true;
                    model.picked = picked;
                    model.filterType = DateFilterType.MANUAL;
                  });
                  refreshWords();
                }
              }, child: Text(() {
                if (model.picked.isEmpty)
                  return "Tap to pick range";
                else
                  return "${model.dateFormat.format(model.picked[0])} to\n${model.dateFormat.format(model.picked[1])}";
              }())),
            )
          ],
        ),
      ],
    );
  }
}