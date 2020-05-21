import 'dart:math';

import 'package:attempt/home/HomeBloc.dart';
import 'package:attempt/home/HomeEvent.dart';
import 'package:attempt/home/ViewState.dart';
import 'package:attempt/search/searchBloc.dart';
import 'package:attempt/search/searchEvent.dart';
import 'package:attempt/showurls/ShowUrlsBloc.dart';
import 'package:attempt/showurls/ShowUrlsEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ArticlesBloc.dart';
import 'ArticlesEvent.dart';
import 'ArticlesState.dart';

class ArticlesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ArticlesViewState();
  }
}

class ArticlesViewState extends State {
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
    BlocProvider.of<ArticlesBloc>(context).add(RefreshArticlesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticlesBloc, ArticlesState>(
        builder: (context, state) {
          if (state is NoArticlesState) {
            return Container(
              child: Center(
                child: Text("No Articles"),
              ),
            );
          } else if (state is LoadingArticlesState) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is LoadedArticlesState) {
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
                        IconButton(
                          icon: Icon(
                            Icons.shuffle,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            BlocProvider.of<ArticlesBloc>(context).add(RandomizeArticlesEvent());
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            BlocProvider.of<ArticlesBloc>(context).add(RefreshArticlesEvent());
                          },
                        )
                      ])),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final title = state.articles[index].title;
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
                              BlocProvider.of<SearchBloc>(context).add(
                                  SearchEvent(title,
                                      exact: true,
                                      updateSearch: true,
                                      addToStack: true));
                              BlocProvider.of<HomeBloc>(context).add(HomeEvent(
                                  title,
                                  viewState:
                                  ViewState.CUSTOM_DEFINITIONS_VIEW));
                              BlocProvider.of<ShowUrlsBloc>(context)
                                  .add(ShowUrlsEvent([state.articles[index].link]));
                            },
                            child: Container(
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 16, bottom: 16),
                                child: Text(
                                  title,
                                  style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.justify,
                                )),
                          ),
                        ),
                      ),
                    );
                  }, childCount: state.articles.length),
                )
              ],
            );
          }
          else {
            throw Exception("Not a valid subtype");
          }
        });
  }
}