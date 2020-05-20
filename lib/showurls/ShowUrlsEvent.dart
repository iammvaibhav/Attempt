import 'package:attempt/repository/model/Word.dart';

class ShowUrlsEvent {
  List<String> urls;
  ShowUrlsEvent(this.urls);
  ShowUrlsEvent.from(Word word) {
    urls = word.definitions;
  }
}