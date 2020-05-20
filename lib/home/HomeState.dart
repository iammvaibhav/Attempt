import 'package:attempt/home/ViewState.dart';

class HomeState {

}

class SlideToPage extends HomeState {
  int pageNo;
  SlideToPage(this.pageNo);
}

class IndexInto extends HomeState {
  ViewState viewState;
  IndexInto(this.viewState);
}