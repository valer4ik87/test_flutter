import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:test_flutter/core/base_list_response.dart';
import 'package:test_flutter/core/retrofit.dart';
import 'package:test_flutter/features/gif/entity/gif_ui.dart';
import 'package:test_flutter/features/gif/model/gif_response.dart';

import '../../core/dio_client.dart';
import '../../env/keys.dart';

class GifRepository {
  final client = RestClient(DioClient().dio);

  Future<Either<String, (bool, List<GifUI>)>> searchGif(
    String searchString,
    int limit,
    int offset,
  ) async {
    try {
      final response = await client.getGifs(
        Keys.gifKey,
        searchString,
        limit,
        offset,
      );
      var newList =
          response?.data?.map((toElement) => GifUI.toGifUI(toElement)) ??
          List.empty();
      var total = response?.pagination?.total_count ?? 0;
      var offsetResponse = response?.pagination?.offset ?? 0;
      var count = response?.pagination?.count ?? 0;
      var isLastPage = total == 0 || count + offsetResponse >= total;
      return Right((isLastPage, newList.toList()));
    } on DioException catch (e) {
      final errorBody = BaseListResponse.fromJson(e.response?.data, (json) {

      },);
      if (errorBody.meta!=null && errorBody.meta?.msg?.isNotEmpty==true) {
        return Left(errorBody.meta?.msg??"");
      } else {
        return Left(e.message??"");
      }
    } catch (e){
      return Left(e.toString());
    }
  }
}
