import '../entity/gif_ui.dart';

abstract class GifState {}

class GifSuccessResponseState extends GifState {
   List<GifUI> listGif;
   int nextKey;
   bool isLastPage;
   GifSuccessResponseState({required this.listGif, required this.nextKey, required this.isLastPage});
}

class GifLoadingState extends GifState {}

class InitState extends GifState {}

class ItemClickedState extends GifState {
   GifUI gifUI;

   ItemClickedState(this.gifUI);
}

class BackClickState extends GifState {
}

class GifErrorState extends GifState {
   String error;

  GifErrorState(this.error);
}