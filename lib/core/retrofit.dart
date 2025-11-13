import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:test_flutter/core/model/base_list_response.dart';
import '../features/gif/model/gif_response.dart';

part 'retrofit.g.dart';

@RestApi(baseUrl: "https://api.giphy.com/v1/")
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET('/gifs/search')
  Future<BaseListResponse<GifResponse>?> getGifs(
    @Query("api_key") String apiKey,
    @Query("q") String searchString,
    @Query("limit") int limit,
    @Query("offset") int offset,
  );
}
