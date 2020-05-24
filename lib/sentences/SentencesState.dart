import 'package:attempt/repository/model/Sentence.dart';

class SentencesState {

}

class UnlimitedSentencesState extends SentencesState {
  List<Sentence> sentences;
  UnlimitedSentencesState(this.sentences);
}

class NoSentencesState extends SentencesState {

}

class LoadingSentencesState extends SentencesState {

}