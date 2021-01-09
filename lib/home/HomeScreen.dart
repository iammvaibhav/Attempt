import 'package:attempt/articles/ArticlesBloc.dart';
import 'package:attempt/articles/ArticlesView.dart';
import 'package:attempt/home/HomeEvent.dart';
import 'package:attempt/home/HomeState.dart';
import 'package:attempt/search/searchBloc.dart';
import 'package:attempt/search/searchEvent.dart';
import 'package:attempt/search/searchScreen.dart';
import 'package:attempt/sentences/SentencesBloc.dart';
import 'package:attempt/sentences/SentencesView.dart';
import 'package:attempt/showurls/ShowUrlsBloc.dart';
import 'package:attempt/showurls/ShowUrlsView.dart';
import 'package:attempt/words/WordsBloc.dart';
import 'package:attempt/words/WordsView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'HomeBloc.dart';
import 'SearchContainer.dart';
import 'ViewState.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[800],
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: MultiBlocProvider(
            providers: [
              BlocProvider<SearchBloc>(
                  create: (context) => SearchBloc()
              ),
              BlocProvider<HomeBloc>(
                create: (context) => HomeBloc(),
              ),
              BlocProvider<SentencesBloc>(
                create: (context) => SentencesBloc(),
              ),
              BlocProvider<WordsBloc>(
                create: (context) => WordsBloc(),
              ),
              BlocProvider<ShowUrlsBloc>(
                create: (context) => ShowUrlsBloc(),
              ),
              BlocProvider<ArticlesBloc>(
                create: (context) => ArticlesBloc(),
              )
            ],
            child: MainContent()
          ),
        ),
      ),
    );
  }
}

class MainContent extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MainContentState();
  }
}

class MainContentState extends State {

  PreloadPageController _controller = PreloadPageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (BlocProvider.of<SearchBloc>(context).isStackEmpty()) {
          final currView = BlocProvider.of<HomeBloc>(context).currView;
          if (currView == ViewState.DEFINITIONS_VIEW) {
            BlocProvider.of<SearchBloc>(context).add(SearchEvent("", updateSearch: true));
            BlocProvider.of<HomeBloc>(context).add(HomeEvent(""));
            return false;
          } else if (currView == ViewState.SENTENCES_VIEW) {
            if (_controller.page != 0) {
              _controller.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.decelerate);
              return false;
            } else return true;
          } else return true;
        }
        else {
          final toSearch = BlocProvider.of<SearchBloc>(context).getEventFromStack();
          BlocProvider.of<SearchBloc>(context).add(SearchEvent(toSearch, exact: true, updateSearch: true, addToStack: false));
          BlocProvider.of<HomeBloc>(context).add(HomeEvent(toSearch));
          return false;
        }
      },
      child: Column(
        children: <Widget>[
          SearchContainer(),
          Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                condition: (previous, current) {
                  return current is IndexInto;
                },
                  builder: (context, state) {
                    return IndexedStack(
                      index: (state as IndexInto).viewState.index,
                      children: [
                        BlocListener<HomeBloc, HomeState>(
                          listener: (BuildContext context, state) {
                            if (state is SlideToPage) {
                              _controller.animateToPage(state.pageNo, curve: Curves.decelerate, duration: Duration(milliseconds: 200));
                            }
                          },
                          child: PreloadPageView(
                            controller: _controller,
                            preloadPagesCount: 2,
                            children: [
                              WordsView(),
                              SentencesView(),
                              ArticlesView()
                            ],
                          ),
                        ),
                        DefinitionsView(),
                        ShowUrlsView()
                      ],
                    );
                  }
              )
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
