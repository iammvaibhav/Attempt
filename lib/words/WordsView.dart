import 'dart:math';

import 'package:attempt/home/HomeBloc.dart';
import 'package:attempt/home/HomeEvent.dart';
import 'package:attempt/home/ViewState.dart';
import 'package:attempt/repository/LearningRepository.dart';
import 'package:attempt/search/searchBloc.dart';
import 'package:attempt/search/searchEvent.dart';
import 'package:attempt/sentences/SentencesBloc.dart';
import 'package:attempt/sentences/SentencesEvent.dart';
import 'package:attempt/showurls/ShowUrlsBloc.dart';
import 'package:attempt/showurls/ShowUrlsEvent.dart';
import 'package:attempt/words/WordsEvent.dart';
import 'package:attempt/words/WordsBloc.dart';
import 'package:attempt/words/WordsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'FilterDropdownButton.dart';
import 'SortDropdownButton.dart';

class WordsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WordsViewState();
  }
}

class WordsViewState extends State {
  final gradients = [
    [Color(0xFFFF6CAB), Color(0xFF7366FF)],
    [Color(0xFFB65EBA), Color(0xFF2E8DE1)],
    [Color(0xFF64E8DE), Color(0xFF8A64EB)],
    [Color(0xFF7BF2E9), Color(0xFFB65EBA)],
    [Color(0xFFFF9482), Color(0xFF7D77FF)],
    [Color(0xFFFFCF1B), Color(0xFFFF881B)],
    [Color(0xFFFFA62E), Color(0xFFEA4D2C)],
    [Color(0xFF00FFED), Color(0xFF00B8BA)],
    [Color(0xFF6EE2F5), Color(0xFF6454F0)],
    [Color(0xFF3499FF), Color(0xFF3A3985)],
    [Color(0xFFFF9897), Color(0xFFF650A0)],
    [Color(0xFFFFCDA5), Color(0xFFEE4D5F)],
    [Color(0xFFFF5B94), Color(0xFF8441A4)],
    [Color(0xFFF869D5), Color(0xFF5650DE)],
    [Color(0xFFF00B51), Color(0xFF7366FF)]
  ];

  // generates a new Random object
  final _random = new Random();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<WordsBloc>(context).add(RefreshWordsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordsBloc, WordsState>(
      builder: (context, state) {
        if (state is NoWordsState) {
          return Container(
            child: Center(
              child: Text("Not learning any words currently."),
            ),
          );
        } else if (state is LoadingWordsState) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is LoadedWordsState) {
          return CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.white,
                titleSpacing: 0,
                title: Container(
                    height: 56,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(children: [
                      SortDropdownButton(),
                      Expanded(
                        child: FilterDropdownButton(),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          BlocProvider.of<WordsBloc>(context).add(ResetAndRefreshWordsEvent());
                        },
                      )
                    ])),
                bottom: PreferredSize(child: Text("Words: ${state.words.length}"), preferredSize: Size.fromHeight(24)),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final word = state.words[index].word;
                  return Container(
                    margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                    child: Material(
                      type: MaterialType.card,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      elevation: 2,
                      child: Ink(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            gradient: LinearGradient(
                                colors: gradients[
                                    _random.nextInt(gradients.length)])),
                        child: InkWell(
                          onTap: () {
                            LearningRepository.getInstance().increaseHitCountFor(word);
                            if (state.words[index].definitions.isNotEmpty) {
                              BlocProvider.of<SearchBloc>(context).add(
                                  SearchEvent(word,
                                      exact: true,
                                      updateSearch: true,
                                      addToStack: true));
                              BlocProvider.of<HomeBloc>(context).add(HomeEvent(
                                  word,
                                  viewState:
                                      ViewState.CUSTOM_DEFINITIONS_VIEW));
                              BlocProvider.of<ShowUrlsBloc>(context)
                                  .add(ShowUrlsEvent.from(state.words[index]));
                            } else {
                              BlocProvider.of<SearchBloc>(context).add(
                                  SearchEvent(word,
                                      exact: true,
                                      updateSearch: true,
                                      addToStack: true));
                              BlocProvider.of<HomeBloc>(context)
                                  .add(HomeEvent(word));
                            }
                          },
                          onLongPress: () {
                            BlocProvider.of<SentencesBloc>(context)
                            .add(ShowSentencesForEvent(word));
                            BlocProvider.of<HomeBloc>(context)
                                .add(HomeEvent(null, slideToPage: 1));
                          },
                          child: Container(
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, top: 16, bottom: 16),
                              child: Text(
                                word,
                                style: GoogleFonts.openSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ),
                    ),
                  );
                }, childCount: state.words.length),
              )
            ],
          );
        } else {
          throw Exception("Not a valid subtype");
        }
      },
    );
  }
}










