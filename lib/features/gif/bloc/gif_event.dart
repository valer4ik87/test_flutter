import '../entity/gif_ui.dart';

abstract class GifEvent {}

class ItemClickEvent extends GifEvent{
    GifUI gifUI;
    ItemClickEvent(this.gifUI);
}

class BackClickEvent extends GifEvent{

}


class FetchDataEvent extends GifEvent {
    int pageKey;
    FetchDataEvent(this.pageKey);
}

class GifNewSearchEvent extends GifEvent {
    String searchString = "";
    GifNewSearchEvent(this.searchString);
}