import 'package:json_annotation/json_annotation.dart';

part 'pagination_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PaginationResponse {
  @JsonKey(name: 'total_count')
  int? totalCount;
  int? count;
  int? offset;

  PaginationResponse({this.totalCount, this.count, this.offset});

  factory PaginationResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationResponseToJson(this);
}
