import 'package:attempt/repository/model/Word.dart';

abstract class Filter {

  bool satisfies(Word word);
}