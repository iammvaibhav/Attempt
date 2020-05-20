import 'package:attempt/repository/model/Sentence.dart';

import 'Filter.dart';

class WordFilter extends Filter {

  final String word;
  WordFilter(this.word);


  @override
  bool satisfies(Sentence sentence) {
    return sentence.word == word;
  }
}