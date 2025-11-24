import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:test_flutter/features/gif/bloc/gif_bloc.dart';
import 'package:test_flutter/features/gif/bloc/gif_event.dart';
import 'package:test_flutter/features/gif/bloc/gif_state.dart';
import 'package:test_flutter/features/gif/gif_grid_view.dart';
import 'package:test_flutter/features/gif/gif_search_input.dart';

import 'entity/gif_ui.dart';

class GifListScreen extends StatefulWidget {
  const GifListScreen({super.key});

  @override
  State<GifListScreen> createState() => _GifListScreenState();
}

class _GifListScreenState extends State<GifListScreen> {
  late final GifBloc _bloc;
  late final _pagingController = PagingController<int, GifUI>(firstPageKey: 0);
  late final PageRequestListener _pageRequestListener;

  @override
  initState() {
    super.initState();
    _bloc = context.read<GifBloc>();
    _pageRequestListener = (pageKey) {
      _bloc.add(FetchDataEvent(pageKey));
    };
    _pagingController.addPageRequestListener(_pageRequestListener);
  }

  @override
  void dispose() {
    _pagingController.removePageRequestListener(_pageRequestListener);
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GifBloc, GifState>(
      listenWhen: (previous, current) {
        return current is GifSuccessResponseState || current is GifErrorState;
      },
      listener: (context, state) {
        if (state is GifSuccessResponseState) {
          if (state.isLastPage) {
            _pagingController.appendLastPage(state.listGif);
          } else {
            _pagingController.appendPage(state.listGif, state.nextKey);
          }
        }
        if (state is GifErrorState) {
          _pagingController.error = state.error;

          showPlatformDialog(
            context: context,
            builder: (_) => PlatformAlertDialog(
              title: const Text('Error'),
              content: Text(state.error),
              actions: [
                PlatformTextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ОК'),
                ),
              ],
            ),
          );
        }
      },
      child: PlatformScaffold(
        appBar: const PlatformAppBar(title: Text('List Gif')),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    GifGridView(pagingController: _pagingController),
                    BlocBuilder<GifBloc, GifState>(
                      buildWhen: (_, state) {
                        return state is GifLoadingState ||
                            state is InitState ||
                            state is GifSuccessResponseState;
                      },
                      builder: (context, state) {
                        return SliverToBoxAdapter(
                          child: state is GifLoadingState
                              ? const Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: PlatformCircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              GifSearchInput(
                pagingController: _pagingController,
                pageRequestListener: _pageRequestListener,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
