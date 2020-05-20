import 'dart:async';
import 'dart:convert';
import 'package:attempt/repository/LearningRepository.dart';
import 'package:attempt/repository/model/Suggestion.dart';
import 'package:dio/dio.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:utf/utf.dart';
import 'package:sqflite/sqflite.dart';
import 'package:attempt/repository/database.dart';

class SuggestionsRepository {

  final dio = Dio();
  final unescape = HtmlUnescape();
  final String _searchURL = "https://www.google.com/complete/search?client=dictionary-widget&requiredfields=corpus%3Aen&q=";

  static SuggestionsRepository _repository;

  static SuggestionsRepository getInstance() {
    if (_repository == null)
      _repository = SuggestionsRepository();
    return _repository;
  }

  Future<void> _insertSuggestions(_Suggestions suggestions) async {
    final Database db = await getDatabase();

    await db.insert(Table.SUGGESTIONS,
        suggestions.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Suggestion>> getSuggestions(String searchKey) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(Table.SUGGESTIONS, where: "searchKey = ?", whereArgs: [searchKey]);
    if (maps.length != 0) { // found in cache
      final suggestions = List<String>();
      final decoded = jsonDecode(maps.first['suggestions']);
      for (var suggestion in decoded) { suggestions.add(suggestion as String); }
      return LearningRepository.getInstance().tagLearningStatus(suggestions);
    } else { // download and cache
      try {
        Response response = await dio.get("$_searchURL$searchKey",
            options: Options(responseType: ResponseType.bytes));

        /**
         * Response bytes are in unicode code point. Need to convert it to utf8 first
         */
        final data = utf8.decode(codepointsToUtf8(response.data));

        final suggestions = List<String>();
        final decodedSuggestions = jsonDecode(data.substring(19, data.length - 1))[1];
        for (var suggestion in decodedSuggestions) { suggestions.add(unescape.convert(suggestion[0])); }
        if (suggestions.isEmpty) {
          suggestions.add(searchKey);
        }

        await _insertSuggestions(_Suggestions(searchKey, suggestions));
        return LearningRepository.getInstance().tagLearningStatus(suggestions);
      } catch (e) {
        //cancelled
        return null;
      }
    }
  }
}

class _Suggestions{
  final String searchKey;
  final List<String> suggestions;

  _Suggestions(this.searchKey, this.suggestions);

  Map<String, dynamic> toMap() {
    return {
      'searchKey': searchKey,
      'suggestions': jsonEncode(suggestions)
    };
  }
}
