import 'package:attempt/repository/model/Category.dart';
import 'package:attempt/words/Resettable.dart';
import 'package:flutter/material.dart';

class CategoryFilterItem extends StatefulWidget {
  final Function refreshWords;
  final CategoryFilterItemStateModel model;

  CategoryFilterItem(this.refreshWords, this.model);

  @override
  State<StatefulWidget> createState() {
    return CategoryFilterItemState(refreshWords, model);
  }
}

class CategoryFilterItemStateModel extends Resettable {
  bool selected;
  String categoryValue;

  CategoryFilterItemStateModel() {
    selected = false;
    categoryValue = Category.ALL;
  }

  void reset() {
    selected = false;
    categoryValue = Category.ALL;
  }
}

class CategoryFilterItemState extends State {
  Function refreshWords;
  final CategoryFilterItemStateModel model;

  CategoryFilterItemState(this.refreshWords, this.model);

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
              SizedBox(width: 32),
              DropdownButton(
                value: model.categoryValue,
                items: Category.all
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(Category.getCategoryName(e)),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    model.selected = true;
                    model.categoryValue = newValue;
                    refreshWords();
                  });
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
