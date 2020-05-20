import 'package:attempt/repository/model/Sentence.dart';

import 'Filter.dart';

class AddedSentencesFilter extends Filter {

  final bool contextualSentences;
  final bool nonContextualSentences;
  AddedSentencesFilter(this.contextualSentences, this.nonContextualSentences);


  @override
  bool satisfies(Sentence sentence) {
    return sentence.category == 'ADDED' && ((contextualSentences ? sentence.word != '' : false) || (nonContextualSentences ? sentence.word == '' : false));
  }
}