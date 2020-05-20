import 'package:bloc/bloc.dart';

import 'ShowUrlsEvent.dart';
import 'ShowUrlsState.dart';

class ShowUrlsBloc extends Bloc<ShowUrlsEvent, ShowUrlsState> {

  @override
  ShowUrlsState get initialState {
    return ShowUrlsState(List());
  }

  @override
  Stream<ShowUrlsState> mapEventToState(ShowUrlsEvent event) async* {
    yield ShowUrlsState(event.urls);
  }
}