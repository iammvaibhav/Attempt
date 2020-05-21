import 'package:attempt/repository/model/Sentence.dart';

class SentencesState {

}

class UnlimitedSentencesState extends SentencesState {
  List<Sentence> sentences;
  bool scrollToTop;
  UnlimitedSentencesState(this.sentences, {this.scrollToTop = false});
}

class NoSentencesState extends SentencesState {

}

class LoadingSentencesState extends SentencesState {

}