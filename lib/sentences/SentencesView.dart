import 'package:attempt/sentences/FilterDropdownButton.dart';
import 'package:attempt/sentences/SentencesEvent.dart';
import 'package:attempt/sentences/SentenceCellView.dart';
import 'package:attempt/sentences/SentencesBloc.dart';
import 'package:attempt/sentences/SentencesState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SentencesView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SentencesViewState();
  }
}

class SentencesViewState extends State {
  
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SentencesBloc>(context).add(LoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SentencesBloc, SentencesState>(
      builder: (context, state) {
        if (state is NoSentencesState) {
          return Container(
            child: Center(
              child: Text("No sentences found"),
            ),
          );
        } else if (state is LoadingSentencesState) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is UnlimitedSentencesState) {

          if (_scrollController.hasClients && !SentencesBloc.preserveScrollPosition) {
            _scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.decelerate);
          }

          return CustomScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.white,
                title: Container(
                    height: 56,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(children: [
                      Expanded(child: FilterDropdownButton()),
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          SentencesBloc.preserveScrollPosition = false;
                          BlocProvider.of<SentencesBloc>(context).add(ResetSentencesEvent());
                        },
                      )
                    ])),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index == state.sentences.length) { //loading view
                    BlocProvider.of<SentencesBloc>(context).add(LoadEvent());
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else return SentenceCellView(state.sentences[index]);
                }, childCount: state.sentences.length + 1),
              )
            ],
          );
        } else {
          throw Exception("Not a valid subtype");
        }
      },
    );
  }
  
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}