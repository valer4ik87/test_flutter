import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:gif_view/gif_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:test_flutter/features/gif/bloc/gif_bloc.dart';
import 'package:test_flutter/features/gif/bloc/gif_event.dart';
import 'package:test_flutter/features/gif/bloc/gif_state.dart';

import 'entity/gif_ui.dart';

class GifListScreen extends StatefulWidget {
  const GifListScreen({super.key});

  @override
  State<GifListScreen> createState() => _GifListScreenState();
}

class _GifListScreenState extends State<GifListScreen> {
  late GifBloc _bloc;
  late final _pagingController = PagingController<int, GifUI>(firstPageKey: 0);
  Timer? _debounce;

  @override
  initState() {
    super.initState();
    _bloc = context.read<GifBloc>();
    _pagingController.addPageRequestListener((pageKey) {
      _bloc.add(FetchDataEvent(pageKey));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
                  child: const Text("ОК"),
                ),
              ],
            ),
          );
        }
      },
      child: PlatformScaffold(
        appBar: const PlatformAppBar(title: Text("List Gif")),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    MyGridView(),
                    BlocBuilder<GifBloc, GifState>(
                      buildWhen: (_, state) {
                        return state is GifLoadingState || state is InitState;
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
              MyInput(_bloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget MyInput(GifBloc bloc) {
    return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: PlatformTextField(
        material: (context, platform) => MaterialTextFieldData(
          decoration: const InputDecoration(
            labelText: 'Search',
            border: OutlineInputBorder(),
          ),
        ),
        cupertino: (context, platform) {
          return CupertinoTextFieldData(
              decoration: BoxDecoration(
                  border: BoxBorder.all(
                      color: const Color.fromARGB(255, 0, 0, 0))));
        },
        onChanged: (text) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            _pagingController.value = const PagingState(
              //Очистка предыдущих данных списка
              nextPageKey: 0,
              error: null,
              itemList: [],
            );
            _bloc.add(GifNewSearchEvent(text));
          });
        },
      ),
    );
  }

  Widget MyGridView() {
    return PagedSliverGrid<int, GifUI>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) {
          return Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: GestureDetector(
                onTap: () {
                  _bloc.add(ItemClickEvent(item));
                },
                child: Column(
                  children: [
                    Expanded(child: GifView.network(item.previewUrl ?? "")),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child:
                          Text(item.title ?? "", textAlign: TextAlign.center),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Author: ${item.author}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ));
        },
        newPageProgressIndicatorBuilder: (context) {
          return const SizedBox.shrink();
        },
        firstPageProgressIndicatorBuilder: (context) {
          return const SizedBox.shrink();
        },
        firstPageErrorIndicatorBuilder: (context) {
          return const SizedBox.shrink();
        },
        noItemsFoundIndicatorBuilder: (context) {
          return const SizedBox.shrink();
        },
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 2,
      ),
    );
  }
}
