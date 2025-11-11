import 'package:test_flutter/features/gif/model/gif_response.dart';

class GifUI {
   String? title;
   String? author;
   String? previewUrl;
   String? originalUrl;

   GifUI({this.title, this.author, this.previewUrl, this.originalUrl});

   static GifUI toGifUI(GifResponse? response){
      return GifUI(title:response?.title, author: response?.userName, previewUrl: response?.images?["preview_gif"]?.url, originalUrl: response?.images?["original"]?.url);
   }
}