// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gif_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GifResponse _$GifResponseFromJson(Map<String, dynamic> json) => GifResponse(
  id: json['id'] as String?,
  title: json['title'] as String?,
  username: json['username'] as String?,
  images: (json['images'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, GifImage.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$GifResponseToJson(GifResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'username': instance.username,
      'images': instance.images,
    };
