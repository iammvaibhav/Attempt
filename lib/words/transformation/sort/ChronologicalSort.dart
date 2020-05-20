import 'package:attempt/repository/model/Word.dart';
import 'package:attempt/words/transformation/sort/Transformation.dart';

class ChronologicalSort extends Transformation {

  bool latestFirst;

  ChronologicalSort(this.latestFirst);

  @override
  void applyTransformation(List<Word> words) {
    words.sort((a, b) {
      if (latestFirst)
        return b.lastUpdated.compareTo(a.lastUpdated);
      else return a.lastUpdated.compareTo(b.lastUpdated);
    });
  }
}