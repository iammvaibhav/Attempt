import 'dart:collection';

import 'package:attempt/repository/model/Word.dart';
import 'package:attempt/words/transformation/filters/Filter.dart';

class AddedSentenceFilter extends Filter {

  bool hasAddedSentences;
  HashSet<String> wordsWithAddedSentences;
  AddedSentenceFilter(this.hasAddedSentences, this.wordsWithAddedSentences);


  @override
  bool satisfies(Word word) {
    return hasAddedSentences ? wordsWithAddedSentences.contains(word.word)
        : !wordsWithAddedSentences.contains(word.word);
  }
}