import 'package:attempt/repository/model/Word.dart';
import 'package:attempt/words/transformation/filters/Filter.dart';

class DefinitionsFilter extends Filter {

  bool hasDefinitions;
  DefinitionsFilter(this.hasDefinitions);

  @override
  bool satisfies(Word word) {
    return hasDefinitions ? word.definitions.isNotEmpty : word.definitions.isEmpty;
  }


}