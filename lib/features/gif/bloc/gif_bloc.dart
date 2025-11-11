import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:test_flutter/features/gif/entity/gif_ui.dart';

import '../gif_repository.dart';
import 'gif_event.dart';
import 'gif_state.dart';


class GifBloc extends Bloc<GifEvent, PagingState<int, GifUI>> {
  final GifRepository gifRepository;

  var searchString = "";
  final limit = 10;


  GifBloc(this.gifRepository) : super(PagingState()) {
    //on<GifSearchEvent>(onSearch);
    on<GifSearchEvent>((event, emit) async{
      final newState = state;
      if (newState.isLoading) return;

      emit(newState.copyWith(isLoading: true, error: null));
      searchString = event.searchString;
      try {
        final newKey = (newState.keys?.last ?? 0) + 1;
        final newItems = await gifRepository.searchGif(
          event.searchString,
          limit,
          newKey*limit,
        );
        final isLastPage = newItems.isEmpty;

        emit(newState.copyWith(
          pages: [...?state.pages, newItems],
          keys: [...?state.keys, newKey],
          hasNextPage: !isLastPage,
          isLoading: false,
        ));
      } catch (error) {
        emit(state.copyWith(
          error: error,
          isLoading: false,
        ));
      }
    },
    );

    on<GifNewSearchEvent>((event, emit) async{
      final newState = state;
        emit(newState.reset());
        add(GifSearchEvent(event.searchString));
    },
    );
  }

  Future<void> onSearch(GifSearchEvent event, Emitter<PagingState<int, GifState>> emit) async {
    emit(PagingState());
    searchString = event.searchString;
  }

}
