
import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';
import 'package:test_flutter/features/gif/model/gif_image.dart';

part 'gif_response.g.dart';

@JsonSerializable()
class GifResponse {
      String? id;
      String? title;
      String? username;
      Map<String,GifImage>? images;

      GifResponse({this.id, this.title, this.username, this.images});


      factory GifResponse.fromJson(Map<String, dynamic> json) =>
          _$GifResponseFromJson(json);

      Map<String, dynamic> toJson() => _$GifResponseToJson(this);
}