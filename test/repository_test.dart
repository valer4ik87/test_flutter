import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter/core/retrofit.dart';
import 'package:test_flutter/features/gif/entity/gif_ui.dart';
import 'package:test_flutter/features/gif/gif_repository.dart';

class MockRepository extends Mock implements GifRepository  {}

void main() {


  late GifRepository repository;
  setUp(() {
    repository = MockRepository();
  });

  test('searchGif returns error', () async {
    when(() => repository.searchGif(any(), any(), any()))
        .thenAnswer((invocation) async{
            return Left("Error");
        }, );

    final result = await repository.searchGif('cat', 10, 0);
    result.fold(
          (l) => expect(l, "Error"),
          (r) => fail("Should not return Right"),
    );
  });

  test('searchGif returns some values', () async {
    final mockGif = [GifUI(author: 'test', originalUrl: '',previewUrl: '',title: ''), GifUI(author: 'test', originalUrl: '',previewUrl: '',title: '')];
    when(() => repository.searchGif(any(), any(), any()))
        .thenAnswer((invocation) async{
      return Right(((false, mockGif)));
    }, );

    final result = await repository.searchGif('cat', 10, 0);
    result.fold(
          (l) => fail("Fail"),
          (r) {
            final (isLastPage, list) = r;
            expect(isLastPage, false);
            expect(list.length, 2);
            expect(list.first, isA<GifUI>());
            expect(list.first.author, 'test');
          },
    );
  });
}
