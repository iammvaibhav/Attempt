import 'package:attempt/home/ViewState.dart';

class HomeEvent {
  String searchText;
  ViewState viewState;
  int slideToPage;
  HomeEvent(this.searchText, {this.viewState, this.slideToPage});
}