import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_flutter/features/gif/bloc/gif_bloc.dart';
import 'package:test_flutter/features/gif/bloc/gif_event.dart';
import 'package:test_flutter/features/gif/bloc/gif_state.dart';
import 'package:test_flutter/features/gif/entity/gif_ui.dart';
import 'package:test_flutter/features/gif/gif_repository.dart';

class MockRepository extends Mock implements GifRepository  {}

void main() {


  late GifRepository repository;
  late GifBloc bloc;
  setUp(() {
    repository = MockRepository();
    bloc = GifBloc(repository);
  });

  test('test search bloc', () async {
    final mockGif = [GifUI(author: 'test', originalUrl: '',previewUrl: '',title: ''), GifUI(author: 'test', originalUrl: '',previewUrl: '',title: '')];
    when(() => repository.searchGif(any(), any(), any()))
        .thenAnswer((invocation) async{
      return Right(((false, mockGif)));
    }, );
    bloc.add(GifNewSearchEvent("test"));
    await expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<GifState>((state) =>
        state is GifLoadingState),
        predicate<GifState>((state) =>
        state is GifSuccessResponseState),
      ]),
    );
  });

  test('test  error search bloc', () async {
    when(() => repository.searchGif(any(), any(), any()))
        .thenAnswer((invocation) async{
      return Left(('Error'));
    }, );
    bloc.add(GifNewSearchEvent("test"));
    await expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<GifState>((state) =>
        state is GifLoadingState),
        predicate<GifState>((state) =>
        state is GifErrorState && state.error=="Error"),
      ]),
    );
  });
}
