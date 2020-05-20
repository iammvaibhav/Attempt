class Sentence {
  String word;
  String category;
  String sentence;
  Sentence(this.word, this.category, this.sentence);

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'category': category,
      'sentence': sentence
    };
  }
}