class SearchEvent {
  String searchText;
  bool exact;
  bool updateSearch;
  bool addToStack;
  SearchEvent(this.searchText, {this.exact = false, this.updateSearch = false, this.addToStack = false});
}