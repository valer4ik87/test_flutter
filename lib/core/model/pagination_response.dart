
import 'package:json_annotation/json_annotation.dart';

part 'pagination_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PaginationResponse {
      int? total_count;
      int? count;
      int? offset;
      PaginationResponse({this.total_count, this.count, this.offset});

      factory PaginationResponse.fromJson(Map<String, dynamic> json) =>
          _$PaginationResponseFromJson(json);

      Map<String, dynamic> toJson() => _$PaginationResponseToJson(this);
}