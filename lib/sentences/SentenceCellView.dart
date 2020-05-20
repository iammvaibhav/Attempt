import 'package:attempt/home/HomeBloc.dart';
import 'package:attempt/home/HomeEvent.dart';
import 'package:attempt/repository/LearningRepository.dart';
import 'package:attempt/repository/model/Category.dart';
import 'package:attempt/repository/model/Sentence.dart';
import 'package:attempt/search/searchBloc.dart';
import 'package:attempt/search/searchEvent.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SentenceCellView extends StatelessWidget {
  final Sentence sentence;
  SentenceCellView(this.sentence);

  @override
  Widget build(BuildContext context) {
    final textSpans = <TextSpan>[];
    sentence.sentence.splitMapJoin(
      RegExp('\\w+'),
      onMatch: (m) {
        final matchStr = m.group(0);

        textSpans.add(TextSpan(
          recognizer: LongPressGestureRecognizer()..onLongPress = () {
            BlocProvider.of<SearchBloc>(context).add(SearchEvent(matchStr.toLowerCase(), exact: true, updateSearch: true, addToStack: true));
            BlocProvider.of<HomeBloc>(context).add(HomeEvent(matchStr.toLowerCase()));
          },
          text: matchStr,
        ));
        return matchStr;
      },
      onNonMatch: (string) {
        textSpans.add(TextSpan(
          text: string,
        ));
        return string;
      },
    );

    return Container(
      margin: EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Material(
        type: MaterialType.card,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        elevation: 2,
        child: InkWell(
          onTap: () {
            LearningRepository.getInstance().increaseHitCountFor(sentence.word);
            BlocProvider.of<SearchBloc>(context).add(SearchEvent(sentence.word, exact: true, updateSearch: true, addToStack: true));
            BlocProvider.of<HomeBloc>(context).add(HomeEvent(sentence.word));
          },
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sentence.word.toUpperCase(),
                      style: GoogleFonts.mandali(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      Category.getCategoryName(sentence.category),
                      style: GoogleFonts.mandali(
                          fontStyle: FontStyle.italic
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyText1.color
                    ),
                    children: textSpans
                  ),
                  textAlign: TextAlign.justify,
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}