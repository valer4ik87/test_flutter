abstract class GifEvent {}

class ItemClick extends GifEvent{}

class FetchDataEvent extends GifEvent {
    int pageKey;
    FetchDataEvent(this.pageKey);
}

class GifNewSearchEvent extends GifEvent {
    String searchString = "";
    GifNewSearchEvent(this.searchString);
}