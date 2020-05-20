import 'dart:math';

import 'package:attempt/repository/model/Word.dart';
import 'package:attempt/words/transformation/sort/Transformation.dart';

class RandomSort extends Transformation {

  @override
  void applyTransformation(List<Word> words) {
    words.shuffle(Random(DateTime.now().millisecondsSinceEpoch));
  }
}