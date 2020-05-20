import 'dart:math';

import 'package:attempt/articles/ArticlesEvent.dart';
import 'package:attempt/articles/ArticlesState.dart';
import 'package:attempt/repository/ArticlesRepository.dart';
import 'package:bloc/bloc.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {

  @override
  ArticlesState get initialState => LoadingArticlesState();

  @override
  Stream<ArticlesState> mapEventToState(ArticlesEvent event) async* {
    yield LoadingArticlesState();

    final articles = await ArticlesRepository.getInstance().getArticles();
    if (articles.isEmpty) {
      yield NoArticlesState();
      return;
    }

    if (event is RandomizeArticlesEvent) {
      articles.shuffle(Random(DateTime.now().millisecondsSinceEpoch));
    }

    yield LoadedArticlesState(articles);
  }
}