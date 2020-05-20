import 'dart:async';

import 'package:attempt/repository/model/Word.dart';
import 'package:firebase_database/firebase_database.dart';

import 'model/Suggestion.dart';

class LearningRepository {
  static LearningRepository _repository;

  static LearningRepository getInstance() {
    if (_repository == null)
      _repository = LearningRepository();
    return _repository;
  }

  Future<void> addLearning(String word) async {
    final timeAdded = DateTime.now().millisecondsSinceEpoch;

    final newKey = FirebaseDatabase.instance.reference().child("words").push();

    await newKey.set({
      "word": word,
      "lastUpdated": timeAdded,
      "hitCount": 1
    });
  }

  Future<void> removeLearning(String word) async {
    final snapshot = await FirebaseDatabase.instance.reference().child("words").orderByChild("word").equalTo(word).once();
    await FirebaseDatabase.instance.reference().child("words").child(snapshot.value.keys.first).remove();
  }

  Future<void> increaseHitCountFor(String word) async {
    final snapshot = await FirebaseDatabase.instance.reference().child("words").orderByChild("word").equalTo(word).once();
    if (snapshot.value != null) {
      await FirebaseDatabase.instance.reference().child("words").child(snapshot.value.keys.first).child("hitCount").runTransaction((mutableData) async {
        mutableData.value = mutableData.value + 1;
        return mutableData;
      });
    }
  }

  Future<List<Word>> getLearningWords() async {
    final snapshot = await FirebaseDatabase.instance.reference().child("words").once();

    final words = <Word>[];
    var result = snapshot.value.values as Iterable;

    for (var item in result) {
      final definitions = <String>[];
      if (item.containsKey("definitions")) {
        var definitionsResult = item["definitions"].values as Iterable;
        for (var item in definitionsResult) {
          definitions.add(item);
        }
      }
      words.add(Word(item["word"], DateTime.fromMillisecondsSinceEpoch(item["lastUpdated"]), item["hitCount"], definitions));
    }

    return words;
  }

  Future<bool> _isLearning(String word) async {
    final snapshotValue = (await FirebaseDatabase.instance.reference().child("words").orderByChild("word").equalTo(word).once()).value;
    return snapshotValue != null;
  }

  Future<List<Suggestion>> tagLearningStatus(List<String> suggestions) async {
    List<Suggestion> taggedSuggestions = List(suggestions.length);

    for (var i = 0; i < suggestions.length; i++) {
      taggedSuggestions[i] = Suggestion(suggestions[i], await LearningRepository.getInstance()._isLearning(suggestions[i]));
    }

    return taggedSuggestions;
  }
}