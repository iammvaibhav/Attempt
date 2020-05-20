import 'package:attempt/repository/model/Word.dart';
import 'package:attempt/words/transformation/filters/Filter.dart';

class MultiWordFilter extends Filter {

  bool hasMultiWord;
  MultiWordFilter(this.hasMultiWord);

  @override
  bool satisfies(Word word) {
    return hasMultiWord ? word.word.split(RegExp(" |-")).length > 1 : word.word.split(RegExp(" |-")).length == 1;
  }
}