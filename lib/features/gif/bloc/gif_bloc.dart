import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:test_flutter/features/gif/entity/gif_ui.dart';

import '../gif_repository.dart';
import 'gif_event.dart';
import 'gif_state.dart';

class GifBloc extends Bloc<GifEvent, GifState> {
  final GifRepository gifRepository;

  var searchString = "";
  final limit = 20;

  GifBloc(this.gifRepository) : super(InitState()) {
    on<FetchDataEvent>((event, emit) async {
      if (searchString.isEmpty) return;
      emit(GifLoadingState());
      final gifs = await gifRepository.searchGif(
        searchString,
        limit,
        event.pageKey * limit,
      );
      gifs.fold(
        (l) {
          emit(GifErrorState(l));
        },
        (r) {
          emit(
            GifSuccessResponseState(
              listGif: r.$2,
              nextKey: event.pageKey + 1,
              isLastPage: r.$1,
            ),
          );
        },
      );
    });

    on<GifNewSearchEvent>((event, emit) async {
      searchString = event.searchString;
      add(FetchDataEvent(0));
    });

    on<ItemClickEvent>((event, emit) {
      emit(ItemClickedState(event.gifUI));
    });
    on<BackClickEvent>((event, emit) {
      emit(BackClickState());
    });
  }
}
