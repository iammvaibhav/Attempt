import 'package:attempt/repository/model/Article.dart';

class ArticlesState {

}

class NoArticlesState extends ArticlesState{

}

class LoadingArticlesState extends ArticlesState {

}

class LoadedArticlesState extends ArticlesState {
  List<Article> articles;
  LoadedArticlesState(this.articles);
}