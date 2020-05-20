import 'package:attempt/repository/model/Word.dart';

abstract class Transformation {
  void applyTransformation(List<Word> words);
}