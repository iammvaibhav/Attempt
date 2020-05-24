import 'dart:collection';

import 'package:attempt/repository/LearningRepository.dart';
import 'package:attempt/repository/SentencesRepository.dart';
import 'package:attempt/repository/model/Word.dart';
import 'package:attempt/words/AddedSentencesFilterItem.dart';
import 'package:attempt/words/DateFilterItem.dart';
import 'package:attempt/words/DefinitionsFilterItem.dart';
import 'package:attempt/words/DownloadedSentencesFilterItem.dart';
import 'package:attempt/words/Resettable.dart';
import 'package:attempt/words/WordsEvent.dart';
import 'package:attempt/words/MultiWordFilterItem.dart';
import 'package:attempt/words/SortDropdownButton.dart';
import 'package:attempt/words/WordsState.dart';
import 'package:attempt/words/transformation/filters/AddedSentencesFilter.dart';
import 'package:attempt/words/transformation/filters/DateFilter.dart';
import 'package:attempt/words/transformation/filters/DefinitionsFilter.dart';
import 'package:attempt/words/transformation/filters/DownloadedSentencesFilter.dart';
import 'package:attempt/words/transformation/filters/Filter.dart';
import 'package:attempt/words/transformation/filters/MultiWordFilter.dart';
import 'package:attempt/words/transformation/sort/AlphabeticalSort.dart';
import 'package:attempt/words/transformation/sort/ChronologicalSort.dart';
import 'package:attempt/words/transformation/sort/HitCountSort.dart';
import 'package:attempt/words/transformation/sort/RandomSort.dart';
import 'package:attempt/words/transformation/sort/WordLengthSort.dart';
import 'package:bloc/bloc.dart';

class WordsBloc extends Bloc<WordsEvent, WordsState> {

  /// Filter state models
  static final dateFilterModel = DateFilterItemStateModel();
  static final addedSentencesFilterItemStateModel = AddedSentencesFilterItemStateModel();
  static final definitionsFilterItemStateModel = DefinitionsFilterItemStateModel();
  static final multiWordFilterItemStateModel = MultiWordFilterItemStateModel();
  static final downloadedSentencesFilterItemStateModel = DownloadedSentencesFilterItemStateModel();
  
  /// Sort state model
  static final sortStateModel = SortDropdownButtonStateModel();
  static var preserveScrollPosition = true;

  @override
  WordsState get initialState => LoadingWordsState();

  @override
  Stream<WordsState> mapEventToState(WordsEvent event) async* {

    if (event is ResetAndRefreshWordsEvent) {
      <Resettable>[dateFilterModel, addedSentencesFilterItemStateModel, definitionsFilterItemStateModel,
      multiWordFilterItemStateModel, downloadedSentencesFilterItemStateModel, sortStateModel].forEach((element) { element.reset(); });
    }

    //now refresh
    List<Word> learningWords = await LearningRepository.getInstance().getLearningWords();

    if (learningWords.length == 0) {
      yield NoWordsState();
      return;
    }

    yield LoadingWordsState();

    // filter and sort
    final filters = <Filter>[];
    if (dateFilterModel.selected) {
      if (dateFilterModel.filterType == DateFilterType.CONVENIENT) {
        var convenientFilterType;
        if (dateFilterModel.convenientValue == "Today") convenientFilterType = ConvenientDateFilterType.TODAY;
        if (dateFilterModel.convenientValue == "Last 24 Hours") convenientFilterType = ConvenientDateFilterType.LAST_24_HOURS;
        if (dateFilterModel.convenientValue == "Yesterday") convenientFilterType = ConvenientDateFilterType.YESTERDAY;
        if (dateFilterModel.convenientValue == "Last 3 Days") convenientFilterType = ConvenientDateFilterType.LAST_3_DAYS;
        if (dateFilterModel.convenientValue == "Last Week") convenientFilterType = ConvenientDateFilterType.LAST_WEEK;
        if (dateFilterModel.convenientValue == "Last Month") convenientFilterType = ConvenientDateFilterType.LAST_MONTH;
        filters.add(DateFilter.from(convenientFilterType));
      } else {
        filters.add(DateFilter(dateFilterModel.picked[0], dateFilterModel.picked[1]));
      }
    }

    if (definitionsFilterItemStateModel.selected) {
      if (definitionsFilterItemStateModel.filterType == DefinitionsFilterType.HAVE_DEFINITIONS) {
        filters.add(DefinitionsFilter(true));
      } else {
        filters.add(DefinitionsFilter(false));
      }
    }

    if (multiWordFilterItemStateModel.selected) {
      if (multiWordFilterItemStateModel.filterType == MultiWordFilterType.HAVE_MULTI_WORDS) {
        filters.add(MultiWordFilter(true));
      } else {
        filters.add(MultiWordFilter(false));
      }
    }

    if (downloadedSentencesFilterItemStateModel.selected) {
      final downloadedWords = await SentencesRepository.getInstance().getWordsHavingSentences();
      print(downloadedWords.length);

      if (downloadedSentencesFilterItemStateModel.filterType == DownloadedSentencesFilterType.HAVE_DOWNLOADED_SENTENCES) {
        filters.add(DownloadedSentencesFilter(true, downloadedWords));
      } else {
        filters.add(DownloadedSentencesFilter(false, downloadedWords));
      }
    }

    if (addedSentencesFilterItemStateModel.selected) {
      //TODO("replace with actual implementation")
      final addedSentences = HashSet<String>();

      if (addedSentencesFilterItemStateModel.filterType == AddedSentencesFilterType.HAVE_ADDED_SENTENCES) {
        filters.add(AddedSentenceFilter(true, addedSentences));
      } else {
        filters.add(AddedSentenceFilter(false, addedSentences));
      }
    }

    final filteredList = learningWords.where((word) => filters.isEmpty ? true : filters.every((filter) => filter.satisfies(word))).toList();

    switch (sortStateModel.currValue) {
      case "Chronological": ChronologicalSort(sortStateModel.sortOrder["Chronological"])
        .applyTransformation(filteredList); break;
      case "Alphabetical": AlphabeticalSort(sortStateModel.sortOrder["Alphabetical"])
        .applyTransformation(filteredList); break;
      case "Hit Count": HitCountSort(sortStateModel.sortOrder["Hit Count"])
        .applyTransformation(filteredList); break;
      case "Word Length": WordLengthSort(sortStateModel.sortOrder["Word Length"])
        .applyTransformation(filteredList); break;
      case "Random": RandomSort().applyTransformation(filteredList); break;
    }

    yield LoadedWordsState(filteredList);
  }
}