import 'package:attempt/repository/model/Word.dart';

class WordsState {

}

class NoWordsState extends WordsState {

}

class LoadingWordsState extends WordsState {

}

class LoadedWordsState extends WordsState {
  List<Word> words;
  LoadedWordsState(this.words);
}