// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gif_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GifResponse _$GifResponseFromJson(Map<String, dynamic> json) => GifResponse(
  id: json['id'] as String?,
  title: json['title'] as String?,
  userName: json['userName'] as String?,
  images: (json['images'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, GifImage.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$GifResponseToJson(GifResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'userName': instance.userName,
      'images': instance.images,
    };
