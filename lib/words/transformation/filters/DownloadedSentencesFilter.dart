import 'dart:collection';
import 'package:attempt/repository/model/Word.dart';
import 'package:attempt/words/transformation/filters/Filter.dart';

class DownloadedSentencesFilter extends Filter {

  bool hasDownloadedSentences;
  HashSet<String> downloadedWords;
  DownloadedSentencesFilter(this.hasDownloadedSentences, this.downloadedWords);

  @override
  bool satisfies(Word word) {
    return hasDownloadedSentences ? downloadedWords.contains(word.word)
        : !downloadedWords.contains(word.word);
  }
}