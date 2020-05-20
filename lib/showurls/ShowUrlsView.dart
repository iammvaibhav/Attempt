import 'package:attempt/search/PlatformVerticalViewGestureRecognizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'ShowUrlsBloc.dart';
import 'ShowUrlsState.dart';

class ShowUrlsView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowUrlsBloc, ShowUrlsState>(
      builder: (context, state) {
        return PreloadPageView(
          children: state.urls.map((e) => WebView(
            key: UniqueKey(),
            initialUrl: e,
            javascriptMode: JavascriptMode.unrestricted,
            gestureRecognizers: [
              Factory(() => PlatformViewVerticalGestureRecognizer()),
            ].toSet(),
          )).toList(),
        );
      },
    );
  }
}