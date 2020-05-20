import 'package:attempt/repository/model/Word.dart';
import 'package:attempt/words/transformation/sort/Transformation.dart';

class AlphabeticalSort extends Transformation {
  
  bool z2a;
  AlphabeticalSort(this.z2a);
  
  @override
  void applyTransformation(List<Word> words) {
    words.sort((a, b) {
      if (z2a)
        return b.word.compareTo(a.word);
      else return a.word.compareTo(b.word);
    });
  }
}