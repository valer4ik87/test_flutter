import 'package:json_annotation/json_annotation.dart';

part 'meta_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class MetaResponse {
  int? status;
  String? msg;
  @JsonKey(name: 'response_id')
  String? responseId;

  MetaResponse({this.status, this.msg, this.responseId});

  factory MetaResponse.fromJson(Map<String, dynamic> json) =>
      _$MetaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MetaResponseToJson(this);
}
