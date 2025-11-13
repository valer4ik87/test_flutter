
import 'package:json_annotation/json_annotation.dart';
import 'package:test_flutter/core/model/meta_response.dart';
import 'package:test_flutter/core/model/pagination_response.dart';

part 'base_list_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseListResponse<T> {
      List<T>? data;
      PaginationResponse? pagination;
      MetaResponse? meta;
      BaseListResponse({this.data, this.pagination, this.meta});

      factory BaseListResponse.fromJson(
          Map<String, dynamic> json,
          T Function(Object? json) fromJsonT,
          ) =>
          _$BaseListResponseFromJson(json, fromJsonT);

      Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
          _$BaseListResponseToJson(this, toJsonT);
}