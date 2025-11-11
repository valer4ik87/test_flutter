
import 'package:json_annotation/json_annotation.dart';

part 'gif_response.g.dart';

@JsonSerializable()
class GifResponse {
      String? id;
      String? title;
      String? userName;

      GifResponse({this.id, this.title, this.userName});


      factory GifResponse.fromJson(Map<String, dynamic> json) =>
          _$GifResponseFromJson(json);

      Map<String, dynamic> toJson() => _$GifResponseToJson(this);
}