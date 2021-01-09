import 'dart:async';
import 'dart:ui';

import 'package:attempt/search/js.dart';
import 'package:attempt/search/searchBloc.dart';
import 'package:attempt/search/searchState.dart';
import 'package:attempt/search/searchEvent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'PlatformVerticalViewGestureRecognizer.dart';


class DefinitionWebView extends StatefulWidget {

  final String initialURL;
  final String channelName;
  final String jsCode;
  final Function searchForFunc;

  DefinitionWebView({this.initialURL, this.channelName, this.jsCode, this.searchForFunc});

  @override
  State createState() {
    return DefinitionWebViewState(
      initialURL: initialURL,
      channelName: channelName,
      jsCode: jsCode,
      searchForFunc: searchForFunc
    );
  }
}

class DefinitionWebViewState extends State {

  final String initialURL;
  final String channelName;
  final String jsCode;
  final Function searchForFunc;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final Completer<void> _loaded = Completer<void>();


  DefinitionWebViewState({this.initialURL, this.channelName, this.jsCode, this.searchForFunc});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
        condition: (previous, current) {
          return previous.searchFor != current.searchFor;
        },
        listener: (context, searchState) {
          _controller.future.then((controller) {
            _loaded.future.then((value) {
              controller.evaluateJavascript(searchForFunc(searchState.searchFor));
            });
          });
        },
        child: WebView(
          debuggingEnabled: true,
          initialUrl: initialURL,
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: {
            JavascriptChannel(
                name: channelName,
                onMessageReceived: (message) {
                  BlocProvider.of<SearchBloc>(context).add(SearchEvent(message.message, exact: true, updateSearch: true, addToStack: true));
                }
            )
          },
          onWebViewCreated: (controller) {
            if (!_controller.isCompleted) {
              _controller.complete(controller);
            }
          },
          onPageFinished: (message) {
            print("Page finished");
            _controller.future.then((controller) {
              controller.evaluateJavascript(jsCode).then((onValue) {
                print("JS injected");
                if (!_loaded.isCompleted)
                  _loaded.complete();
              }, onError: (error) {
                print("on error:");
                print(error);
              });
            });
          },
          gestureRecognizers: [
            Factory(() => PlatformViewVerticalGestureRecognizer()),
          ].toSet(),
        )
    );
  }
}

class DefinitionsView extends StatelessWidget { // Screen 1

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return Container(
                height: 64,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    itemCount: state.suggestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          if (index > 0) {
                            BlocProvider.of<SearchBloc>(context).add(SearchEvent(state.suggestions[index].suggestion, exact: true, updateSearch: true));
                          } else {
                            if (state.suggestions[0].isLearning) {
                              BlocProvider.of<SearchBloc>(context).removeFromLearning(state.suggestions[0].suggestion);
                            } else {
                              BlocProvider.of<SearchBloc>(context).addToLearning(state.suggestions[0].suggestion);
                            }
                          }
                        },
                        child: Container(
                          height: 32,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                              gradient: LinearGradient(colors: state.suggestions[index].isLearning ? [Color.fromARGB(255, 255, 207, 24), Color.fromARGB(255, 255, 136, 27)] : [Colors.white, Colors.white]),
                              boxShadow: [BoxShadow(blurRadius: 6, spreadRadius: 4, color: state.suggestions[index].isLearning ? Color.fromARGB(80, 255, 136, 27) : Color.fromARGB(20, 0, 59, 255))]
                          ),
                          margin: EdgeInsets.only(right: 16),
                          child: Center(
                              child: Text(
                                state.suggestions[index].suggestion,
                                style: TextStyle(
                                    color: state.suggestions[index].isLearning ? Colors.white : Colors.blue[800],
                                    fontWeight: FontWeight.bold
                                ),
                              )
                          ),
                        ),
                      );
                    }
                ),
              );
            },
          ),
          Expanded(
              child: PreloadPageView(
                preloadPagesCount: 2,
                  children: <Widget>[
                    DefinitionWebView(
                      initialURL: GoogleDictionaryURL,
                      channelName: GoogleDictionaryJSChannelName,
                      jsCode: GoogleDictionaryJS,
                      searchForFunc: googleDictionaryJSSearchFor,
                    ),
                    DefinitionWebView(
                      initialURL: VocabularyURL,
                      channelName: VocabularyJSChannelName,
                      jsCode: VocabularyJS,
                      searchForFunc: vocabularyJSSearchFor,
                    ),
                  ]
              )
          )
        ]
    );
  }
}