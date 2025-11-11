import 'package:test_flutter/core/retrofit.dart';
import 'package:test_flutter/features/gif/entity/gif_ui.dart';

import '../../core/dio_client.dart';
import '../../env/keys.dart';

class GifRepository {
  final client = RestClient(DioClient().dio);

  Future<List<GifUI>> searchGif(String searchString, int limit, int offset) async {
    final response = await client.getGifs(Keys.gifKey, searchString, limit, offset);
    var newList = response?.data?.map((toElement) => GifUI.toGifUI(toElement))??List.empty();
    return newList.toList();
  }
}
