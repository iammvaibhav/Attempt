class SentencesEvent {

}

class LoadEvent extends SentencesEvent {

}

/// Called whenever any filter is changed
class FilterSentencesEvent extends SentencesEvent {

}

/// Called when reset button is pressed. Reset all filters.
class ResetSentencesEvent extends SentencesEvent {

}

class ShowSentencesForEvent extends SentencesEvent {
  String word;
  ShowSentencesForEvent(this.word);
}