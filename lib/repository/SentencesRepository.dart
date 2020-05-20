import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:attempt/repository/database.dart';

import 'package:dio/dio.dart';
import 'model/Sentence.dart';
import 'model/Category.dart';

class SentencesRepository {
  static SentencesRepository _repository;
  final dio = Dio();

  static SentencesRepository getInstance() {
    if (_repository == null)
      _repository = SentencesRepository();
    return _repository;
  }

  Future<void> downloadSentencesFor(String word) async {
    await _setDownloadStatus(word, SentencesDownloadStatus.NOT_DOWNLOADED);

    var allTasks = <Future<Response>>[];
    Category.all.forEach((category) {
      allTasks.add(dio.get(_getURL(word, category)));
    });

    List<Response> responses = await Future.wait(allTasks);

    final downloadStatus = await _getDownloadStatus(word);
    if (downloadStatus == SentencesDownloadStatus.SHOULD_DISCARD)
      return;

    final db = await getDatabase();
    await db.transaction((txn) async {
      final batch = txn.batch();

      for (var i = 0; i < Category.all.length; i++) {
        String category = Category.all[i];
        dynamic response = responses[i].data;

        for (var sentenceStruct in response["result"]["sentences"]) {
          String sentence = sentenceStruct["sentence"];
          batch.insert(Table.SENTENCES, Sentence(word, category, sentence).toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }

      batch.commit(noResult: true);
    });

    await _setDownloadStatus(word, SentencesDownloadStatus.DOWNLOADED);
  }

  Future<void> downloadIfNotDownloaded(String word) async {
    final db = await getDatabase();

    List<Map<String, dynamic>> rows = await db.query(Table.SENTENCES_DOWNLOADS,
        where: "word = ?", whereArgs: [word]);

    if (rows.length == 0) {
      await downloadSentencesFor(word);
    }
  }

  Future<void> downloadNonDownloadedSentences() async {
    final db = await getDatabase();

    List<Map<String, dynamic>> rows = await db.query(Table.SENTENCES_DOWNLOADS,
        where: "status = ?", whereArgs: [SentencesDownloadStatus.NOT_DOWNLOADED.index]);

    for (var row in rows) {
      downloadSentencesFor(row['word']);
    }
  }

  Future<void> removeSentencesFor(String word) async {
    final downloadStatus = await _getDownloadStatus(word);

    if (downloadStatus == SentencesDownloadStatus.NOT_DOWNLOADED) { //download is in progress
      _setDownloadStatus(word, SentencesDownloadStatus.SHOULD_DISCARD);
      return;
    } else {
      final Database db = await getDatabase();
      await db.delete(Table.SENTENCES, where: "word = ?", whereArgs: [word]);
      await db.delete(Table.SENTENCES_DOWNLOADS, where: "word = ?", whereArgs: [word]);
    }
  }

  Future<HashSet<String>> getWordsHavingSentences() async {
    final Database db = await getDatabase();

    List<Map<String, dynamic>> rows = await db.query(Table.SENTENCES, distinct: true, columns: ["word"]);
    final downloadedWords = HashSet<String>();

    for (var row in rows) {
      downloadedWords.add(row['word']);
    }

    return downloadedWords;
  }



  /// Just for documentation
  /// random sentences in random order: SELECT * FROM (SELECT * FROM ${Table.SENTENCES} ORDER BY RANDOM()) GROUP BY word ORDER BY RANDOM();
  /// Now we want random sentences but don't randomize order here. We'll shuffle after adding added sentences
  Future<List<Sentence>> getDownloadedSentences() async {
    final Database db = await getDatabase();

    final List<Map<String, dynamic>> rows = await db.rawQuery("SELECT * FROM (SELECT * FROM ${Table.SENTENCES} ORDER BY RANDOM()) GROUP BY word");

    final sentences = List<Sentence>();
    for (var row in rows) {
      sentences.add(Sentence(row['word'], row['category'], row['sentence']));
    }

    return sentences;
  }

  Future<List<Sentence>> getContextualSentences() async {
    final snapshot = await FirebaseDatabase.instance.reference().child("sentences-data").child("contextual").once();
    final sentences = List<Sentence>();
    if (snapshot.value != null) {
      final sentencesData = snapshot.value.values as Iterable;
      for (var data in sentencesData) {
        final wordSentences = (data["sentences"].values as Iterable).toList();
        sentences.addAll(wordSentences.map((e) => Sentence(data["word"], "ADDED", e)));
      }
    }
    
    return sentences;
  }
  
  Future<List<Sentence>> getSentencesFor(String word) async {
    final snapshot = await FirebaseDatabase.instance.reference().child("sentences-data").child("contextual").orderByChild("word").equalTo(word).once();
    final sentences = List<Sentence>();
    if (snapshot.value != null) {
      final result = snapshot.value.values.first["sentences"].values as Iterable;
      for (var sentence in result) {
        sentences.add(Sentence(word, "ADDED", sentence));
      }
    }
    return sentences;
  }

  Future<List<Sentence>> getDownloadedSentencesFor(String word) async {
    final Database db = await getDatabase();

    final List<Map<String, dynamic>> rows = await db.query(Table.SENTENCES, where: "word = ?", whereArgs: [word]);

    final sentences = List<Sentence>();
    for (var row in rows) {
      sentences.add(Sentence(row['word'], row['category'], row['sentence']));
    }

    return sentences;
  }

  Future<List<Sentence>> getNonContextualSentences() async {
    final snapshot = await FirebaseDatabase.instance.reference().child("sentences-data").child("non-contextual").once();
    final sentences = List<Sentence>();
    if (snapshot.value != null) {
      final result = snapshot.value.values as Iterable;
      for (var sentence in result) {
        sentences.add(Sentence("", "ADDED", sentence));
      }
    }
    return sentences;
  }

  Future<SentencesDownloadStatus> _getDownloadStatus(String word) async {
    final Database db = await getDatabase();

    List<Map<String, dynamic>> rows = await db.query(Table.SENTENCES_DOWNLOADS, where: "word = ?", whereArgs: [word]);

    if (rows.length == 0) return null;
    else return SentencesDownloadStatus.values[rows[0]['status']];
  }

  Future<void> _setDownloadStatus(String word, SentencesDownloadStatus status) async {
    final database = await getDatabase();
    await database.insert(Table.SENTENCES_DOWNLOADS,
    {
      "word": word,
      "status": status.index
    },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// 24 results of given category
  String _getURL(String word, String category) {
    if (category == Category.ALL) {
      return "https://corpus.vocabulary.com/api/1.0/examples.json?query=${word.split(" ").join("+")}&maxResults=24&startOffset=0";
    }
    return "https://corpus.vocabulary.com/api/1.0/examples.json?query=${word.split(" ").join("+")}&maxResults=24&startOffset=0&domain=$category";
  }
}


