abstract class GifEvent {}

class ItemClick extends GifEvent{}

class GifSearchEvent extends GifEvent {
    String searchString = "";

    GifSearchEvent(this.searchString);
}