import 'package:attempt/words/Resettable.dart';
import 'package:attempt/words/WordsBloc.dart';
import 'package:flutter/material.dart';

class DownloadedSentencesFilterItem extends StatefulWidget {

  final Function refreshWords;
  DownloadedSentencesFilterItem(this.refreshWords);

  @override
  State<StatefulWidget> createState() {
    return DownloadedSentencesFilterItemState(refreshWords);
  }
}

enum DownloadedSentencesFilterType {
  HAVE_DOWNLOADED_SENTENCES,
  DO_NOT_HAVE_DOWNLOADED_SENTENCES
}

class DownloadedSentencesFilterItemStateModel extends Resettable{
  bool selected;
  DownloadedSentencesFilterType filterType;

  DownloadedSentencesFilterItemStateModel() {
    selected = false;
    filterType = DownloadedSentencesFilterType.HAVE_DOWNLOADED_SENTENCES;
  }

  void reset() {
    selected = false;
    filterType = DownloadedSentencesFilterType.HAVE_DOWNLOADED_SENTENCES;
  }
}

class DownloadedSentencesFilterItemState extends State {

  final model = WordsBloc.downloadedSentencesFilterItemStateModel;
  Function refreshWords;
  DownloadedSentencesFilterItemState(this.refreshWords);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        onTap: () {
          setState(() {
            model.selected = !model.selected;
            refreshWords();
          });
        },
        child: Row(
          children: [
            Checkbox(
              value: model.selected,
              onChanged: (value) {
                setState(() {
                  model.selected = value;
                  refreshWords();
                });
              },
            ),
            Expanded(child: Text("Downloaded Sentences:"))
          ],
        ),
      ),
      InkWell(
        onTap: () {
          setState(() {
            model.selected = true;
            model.filterType = DownloadedSentencesFilterType.HAVE_DOWNLOADED_SENTENCES;
            refreshWords();
          });
        },
        child: Row(children: [
          SizedBox(width: 32),
          Radio(
              value: DownloadedSentencesFilterType.HAVE_DOWNLOADED_SENTENCES,
              groupValue: model.filterType,
              onChanged: (newValue) {
                setState(() {
                  model.selected = true;
                  model.filterType = newValue;
                  refreshWords();
                });
              }),
          Expanded(child: const Text('Have'))
        ]),
      ),
      InkWell(
        onTap: () {
          setState(() {
            model.selected = true;
            model.filterType = DownloadedSentencesFilterType.DO_NOT_HAVE_DOWNLOADED_SENTENCES;
            refreshWords();
          });
        },
        child: Row(children: [
          SizedBox(width: 32),
          Radio(
              value: DownloadedSentencesFilterType
                  .DO_NOT_HAVE_DOWNLOADED_SENTENCES,
              groupValue: model.filterType,
              onChanged: (newValue) {
                setState(() {
                  model.selected = true;
                  model.filterType = newValue;
                  refreshWords();
                });
              }),
          Expanded(child: const Text('Don\'t Have'))
        ]),
      )
    ]);
  }
}
