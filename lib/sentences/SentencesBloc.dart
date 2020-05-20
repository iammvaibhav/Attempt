import 'dart:collection';
import 'dart:math';

import 'package:attempt/repository/LearningRepository.dart';
import 'package:attempt/repository/SentencesRepository.dart';
import 'package:attempt/repository/model/Sentence.dart';
import 'package:attempt/repository/model/Word.dart';
import 'package:attempt/sentences/AddedSentencesFilterItem.dart';
import 'package:attempt/sentences/CategoryFilterItem.dart';
import 'package:attempt/sentences/SentencesEvent.dart';
import 'package:attempt/sentences/SentencesState.dart';
import 'package:attempt/sentences/filters/AddedSentencesFilter.dart';
import 'package:attempt/sentences/filters/CategoryFilter.dart';
import 'package:attempt/sentences/filters/DateFilter.dart';
import 'package:attempt/sentences/filters/Filter.dart';
import 'package:attempt/words/DateFilterItem.dart';
import 'package:attempt/words/Resettable.dart';
import 'package:bloc/bloc.dart';

class SentencesBloc extends Bloc<SentencesEvent, SentencesState> {
  final sentences = List<Sentence>();

  static final dateFilterItemStateModel = DateFilterItemStateModel();
  static final addedSentencesFilterItemStateModel =
      AddedSentencesFilterItemStateModel();
  static final categoryFilterItemStateModel = CategoryFilterItemStateModel();
  String wordFilter;

  SentencesState get initialState => LoadingSentencesState();

  @override
  Stream<SentencesState> mapEventToState(SentencesEvent event) async* {

    if (event is ResetSentencesEvent) {
      sentences.clear();
      wordFilter = null;
      <Resettable>[
        dateFilterItemStateModel,
        addedSentencesFilterItemStateModel,
        categoryFilterItemStateModel
      ].forEach((element) {
        element.reset();
      });
    } else if (event is FilterSentencesEvent) {
      sentences.clear();
    } else if (event is ShowSentencesForEvent) {
      sentences.clear();
      wordFilter = event.word;
    }

    List<Sentence> sentencesSet = [];

    // Apply wordFilter here only
    if (wordFilter != null) {
      sentencesSet.addAll(await SentencesRepository.getInstance().getDownloadedSentencesFor(wordFilter));
      sentencesSet.addAll(await SentencesRepository.getInstance().getSentencesFor(wordFilter));
    } else {
      sentencesSet.addAll(await SentencesRepository.getInstance().getDownloadedSentences());
      sentencesSet.addAll(await SentencesRepository.getInstance().getContextualSentences());
      sentencesSet.addAll(await SentencesRepository.getInstance().getNonContextualSentences());
    }

    sentencesSet.shuffle(Random(DateTime.now().millisecondsSinceEpoch));

    if (sentencesSet.length == 0) {
      yield NoSentencesState();
      return;
    }

    final filters = <Filter>[];

    if (dateFilterItemStateModel.selected) {
      final lastUpdatedData = HashMap<String, DateTime>();

      List<Word> words = await LearningRepository.getInstance().getLearningWords();

      words.forEach((element) {
        lastUpdatedData[element.word] = element.lastUpdated;
      });

      if (dateFilterItemStateModel.filterType == DateFilterType.CONVENIENT) {
        filters.add(DateFilter.from(dateFilterItemStateModel.convenientValue, lastUpdatedData));
      } else {
        filters.add(DateFilter(dateFilterItemStateModel.picked[0], dateFilterItemStateModel.picked[1], lastUpdatedData));
      }
    }

    if (addedSentencesFilterItemStateModel.selected) {

      filters.add(AddedSentencesFilter(addedSentencesFilterItemStateModel.contextualSentences,
          addedSentencesFilterItemStateModel.nonContextualSentences));

    }

    if (categoryFilterItemStateModel.selected) {
      filters.add(CategoryFilter(categoryFilterItemStateModel.categoryValue));
    }

    /*if (wordFilter != null) {
      filters.add(WordFilter(wordFilter));
    }*/

    sentences.addAll(sentencesSet.where((sentences) => filters.isEmpty ? true : filters.every((filter) => filter.satisfies(sentences))));

    yield UnlimitedSentencesState(sentences);

  }
}
