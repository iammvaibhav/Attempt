import 'package:attempt/home/HomeEvent.dart';
import 'package:attempt/search/searchBloc.dart';
import 'package:attempt/search/searchEvent.dart';
import 'package:attempt/search/searchState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'HomeBloc.dart';

class SearchBar extends StatefulWidget {

  @override
  State createState() {
    return SearchBarState();
  }
}

class SearchBarState extends State {

  final _controller = TextEditingController();
  var prevText = "";
  Function _searchTextListener;
  bool showClear = false;

  @override
  void initState() {
    _searchTextListener = () {
      setState(() {
        showClear = _controller.text != "";
      });
      if (prevText != _controller.text) { //prevent it from getting called multiple times
        prevText = _controller.text;
        BlocProvider.of<SearchBloc>(context).add(SearchEvent(_controller.text));
        BlocProvider.of<HomeBloc>(context).add(HomeEvent(_controller.text));
      }
    };

    _controller.addListener(_searchTextListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      condition: (previous, current) {
        return current.updateSearch;
      },
      listener: (context, searchState) {
        _controller.removeListener(_searchTextListener);
        prevText = searchState.searchText;
        _controller.value = TextEditingValue(text: searchState.searchText,
            selection: TextSelection.fromPosition(TextPosition(offset: searchState.searchText.length)));
        _controller.addListener(_searchTextListener);
      },
      child: Material(
        type: MaterialType.card,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.only(left: 8),
          child: TextField(
            controller: _controller,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 17, left: -5),
                icon: Icon(
                  Icons.search,
                  size: 24,
                  color: Colors.grey[800],
                ),
                suffixIcon: Visibility(
                  visible: showClear,
                  child: IconButton(
                    iconSize: 12,
                    icon: Container(
                      padding: EdgeInsets.all(2),
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[800]
                      ),
                    ),
                    onPressed: () {
                      _controller.text = "";
                    },
                  ),
                )
            ),
            onSubmitted: (searchText) {
              BlocProvider.of<SearchBloc>(context).add(SearchEvent(searchText, exact: true));
              BlocProvider.of<HomeBloc>(context).add(HomeEvent(searchText));
            },
          ),
        ),
      ),
    );
  }
}