import 'package:attempt/repository/model/Suggestion.dart';

class SearchState {
  String searchText; //user inputted search text
  List<Suggestion> suggestions;
  String searchFor; //first suggestion
  bool updateSearch;
  bool backEnabled;
  SearchState(this.searchText, this.suggestions, this.searchFor, this.updateSearch, this.backEnabled);
}