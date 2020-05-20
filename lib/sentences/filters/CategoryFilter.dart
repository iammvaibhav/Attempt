import 'package:attempt/repository/model/Sentence.dart';

import 'Filter.dart';

class CategoryFilter extends Filter {

  final String categoryValue;
  CategoryFilter(this.categoryValue);


  @override
  bool satisfies(Sentence sentence) {
    return sentence.category == categoryValue;
  }
}