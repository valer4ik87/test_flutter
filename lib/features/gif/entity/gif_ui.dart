import 'package:test_flutter/features/gif/model/gif_response.dart';

class GifUI {
   String? title;
   String? author;
   String? url;

   GifUI({this.title, this.author, this.url});

   static GifUI toGifUI(GifResponse? response){
      return GifUI(title:response?.title, author: response?.userName, url: "");
   }
}