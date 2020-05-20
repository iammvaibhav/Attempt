import 'package:attempt/home/HomeEvent.dart';
import 'package:attempt/home/HomeState.dart';
import 'package:attempt/home/ViewState.dart';
import 'package:bloc/bloc.dart';

/// Used for changing Sentences View to Definition View
///
/// State 0: Sentences View
/// State 1: Definition View
class HomeBloc extends Bloc<HomeEvent, HomeState> {

  ViewState currView = ViewState.SENTENCES_VIEW;

  @override
  HomeState get initialState => IndexInto(ViewState.SENTENCES_VIEW);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event.slideToPage != null) {
      yield SlideToPage(event.slideToPage);
      return;
    }

    if (event.viewState != null) {
      currView = event.viewState;
    } else {
      currView = event.searchText.length > 0 ? ViewState.DEFINITIONS_VIEW : ViewState.SENTENCES_VIEW;
    }

    yield IndexInto(currView);
  }
}