

import 'package:json_annotation/json_annotation.dart';

part 'gif_image.g.dart';

@JsonSerializable()
class GifImage {
  String? url;

  GifImage({this.url,});


  factory GifImage.fromJson(Map<String, dynamic> json) =>
      _$GifImageFromJson(json);

  Map<String, dynamic> toJson() => _$GifImageToJson(this);
}