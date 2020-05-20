import 'package:attempt/repository/model/Word.dart';
import 'package:attempt/words/transformation/sort/Transformation.dart';

class WordLengthSort extends Transformation {

  bool longestFirst;

  WordLengthSort(this.longestFirst);

  @override
  void applyTransformation(List<Word> words) {
    words.sort((a, b) {
      if (longestFirst)
        return b.word.length.compareTo(a.word.length);
      else return a.word.length.compareTo(b.word.length);
    });
  }
}