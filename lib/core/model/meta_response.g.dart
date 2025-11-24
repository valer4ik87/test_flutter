// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaResponse _$MetaResponseFromJson(Map<String, dynamic> json) => MetaResponse(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      responseId: json['response_id'] as String?,
    );

Map<String, dynamic> _$MetaResponseToJson(MetaResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'response_id': instance.responseId,
    };
