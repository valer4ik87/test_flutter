import '../entity/gif_ui.dart';

abstract class GifState {}

class GifSuccessResponse extends GifState {
   final List<GifUI> listGif;
   final int nextKey;
   final bool isLastPage;
   GifSuccessResponse({required this.listGif, required this.nextKey, required this.isLastPage});
}

class GifLoading extends GifState {}

class InitState extends GifState {}

class GifError extends GifState {
   final String error;

  GifError(this.error);
}