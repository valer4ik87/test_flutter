import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:test_flutter/features/gif/entity/gif_ui.dart';

import '../gif_repository.dart';
import 'gif_event.dart';
import 'gif_state.dart';


class GifBloc extends Bloc<GifEvent, GifState> {
  final GifRepository gifRepository;
  late final PagingController<int, GifUI> pagingController;

  var searchString = "";
  final limit = 20;


  GifBloc(this.gifRepository) : super(InitState()) {
    pagingController = PagingController<int, GifUI>(
      fetchPage: (pageKey) async {
        final gifs = await gifRepository.searchGif(
          searchString,
          limit,
          pageKey*limit,
        );
        return gifs??List.empty();
      },
      getNextPageKey: (state) {
        final lastPageIsEmpty = state.pages?.isEmpty==true || state.pages?.last.isEmpty==true;
        if (lastPageIsEmpty) return null;
        final lastKey = state.nextIntPageKey;
        return lastKey;
      },
    );
    on<GifSearchEvent>(onSearch);

  }

  Future<void> onSearch(GifSearchEvent event, Emitter<GifState> emit) async {
    emit(GifLoading());
    searchString = event.searchString;
    pagingController.refresh();
    pagingController.fetchNextPage();
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }

}
