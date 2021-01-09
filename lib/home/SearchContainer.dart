import 'package:attempt/home/HomeBloc.dart';
import 'package:attempt/home/HomeEvent.dart';
import 'package:attempt/home/ViewState.dart';
import 'package:attempt/search/searchBloc.dart';
import 'package:attempt/search/searchEvent.dart';
import 'package:attempt/search/searchState.dart';
import 'package:attempt/sentences/SentencesEvent.dart';
import 'package:attempt/sentences/SentencesBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'SearchBar.dart';

class SearchContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[800],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              child: Material(
                type: MaterialType.card,
                color: Colors.white,
                elevation: 8,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    return IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.arrow_back_ios_outlined),
                      onPressed: state.backEnabled ? () {
                        final toSearch = BlocProvider.of<SearchBloc>(context).getEventFromStack();
                        BlocProvider.of<SearchBloc>(context).add(SearchEvent(toSearch, exact: true, updateSearch: true, addToStack: false));
                        BlocProvider.of<HomeBloc>(context).add(HomeEvent(toSearch));
                      } : null,
                      color: Colors.blue[800],
                    );
                  }
                ),
              ),
            ),
            Container(
              height: 35,
              width: 35,
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Material(
                type: MaterialType.card,
                color: Colors.white,
                elevation: 8,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.home),
                    onPressed: () {
                      BlocProvider.of<SearchBloc>(context).clearStack();
                      BlocProvider.of<SearchBloc>(context).add(SearchEvent("", updateSearch: true));
                      BlocProvider.of<HomeBloc>(context).add(HomeEvent(""));
                      FocusScope.of(context).unfocus();
                    },
                    color: Colors.blue[800]
                ),
              ),
            ),
            Expanded(
              child: Container(
                  height: 35,
                  child: SearchBar()
              ),
            )
          ],
        ),
      ),
    );
  }
}