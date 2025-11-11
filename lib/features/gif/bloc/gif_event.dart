abstract class GifEvent {}

class ItemClick extends GifEvent{}

class GifSearchEvent extends GifEvent {
    String searchString = "";

    GifSearchEvent(this.searchString);
}

class GifNewSearchEvent extends GifEvent {
    String searchString = "";

    GifNewSearchEvent(this.searchString);
}