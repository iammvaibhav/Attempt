import 'package:attempt/repository/LearningRepository.dart';
import 'package:attempt/repository/SentencesRepository.dart';
import 'package:attempt/repository/model/Suggestion.dart';
import 'package:attempt/search/searchEvent.dart';
import 'package:attempt/search/searchState.dart';
import 'package:attempt/repository/SuggestionsRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {

  SearchEvent currEvent;
  String currSearch = "";
  final stack = <String>[];

  @override
  SearchState get initialState {
    return SearchState("", List(), "", false, stack.isNotEmpty);
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event.addToStack) {
      stack.add(currSearch);
    }

    currEvent = event;

    if (event.searchText.isEmpty) {
      currSearch = "";
      yield SearchState("", List(), "", event.updateSearch, stack.isNotEmpty);
      return;
    } else if (event.exact) {
      currSearch = event.searchText;
      yield SearchState(event.searchText,
          await LearningRepository.getInstance().tagLearningStatus([event.searchText]),
          event.searchText, event.updateSearch, stack.isNotEmpty);
      return;
    }

    List<Suggestion> suggestions = await SuggestionsRepository.getInstance().getSuggestions(event.searchText);
    if (suggestions != null) {
      currSearch = suggestions.first.suggestion;
      yield SearchState(event.searchText, suggestions, suggestions.first.suggestion, event.updateSearch, stack.isNotEmpty);
    }
  }

  @override
  Stream<SearchState> transformEvents(events, next) => events.switchMap(next);

  void addToLearning(String word) async {
    await LearningRepository.getInstance().addLearning(word);
    _refresh();
    SentencesRepository.getInstance().downloadSentencesFor(word);
  }

  void removeFromLearning(String word) async {
    await LearningRepository.getInstance().removeLearning(word);
    _refresh();
    SentencesRepository.getInstance().removeSentencesFor(word);
  }

  String getEventFromStack() {
    return stack.removeLast();
  }

  bool isStackEmpty() {
    return stack.isEmpty;
  }

  void clearStack() {
    stack.clear();
  }

  void _refresh() {
    if (currEvent != null)
      add(currEvent);
  }
}