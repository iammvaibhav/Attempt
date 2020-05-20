import 'package:attempt/repository/model/Article.dart';
import 'package:firebase_database/firebase_database.dart';

class ArticlesRepository {
  static ArticlesRepository _repository;

  static ArticlesRepository getInstance() {
    if (_repository == null)
      _repository = ArticlesRepository();
    return _repository;
  }

  Future<List<Article>> getArticles() async {
    final snapshot = await FirebaseDatabase.instance.reference().child("articles").once();
    if (snapshot.value == null)
        return List();

    final result = snapshot.value.values as Iterable;
    final articles = <Article>[];
    for (final article in result) {
      articles.add(Article(article["title"], article["link"]));
    }

    print(articles);
    return articles;
  }
}