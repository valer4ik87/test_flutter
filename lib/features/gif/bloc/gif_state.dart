import '../entity/gif_ui.dart';

abstract class GifState {}

class GifSuccessResponse extends GifState {
   final List<GifUI>? listGif;
   GifSuccessResponse(this.listGif);
}

class GifLoading extends GifState {}

class InitState extends GifState {}

class GifError extends GifState {
   final String error;

  GifError(this.error);
}