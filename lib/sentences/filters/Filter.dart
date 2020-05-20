import 'package:attempt/repository/model/Sentence.dart';

abstract class Filter {

  bool satisfies(Sentence sentence);
}