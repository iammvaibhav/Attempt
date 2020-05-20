import 'package:attempt/repository/model/Word.dart';
import 'package:attempt/words/transformation/sort/Transformation.dart';

class HitCountSort extends Transformation {

  bool highestHitFirst;
  HitCountSort(this.highestHitFirst);

  @override
  void applyTransformation(List<Word> words) {
    words.sort((a, b) {
      if (highestHitFirst)
        return b.hitCount.compareTo(a.hitCount);
      else return a.hitCount.compareTo(b.hitCount);
    });
  }
}