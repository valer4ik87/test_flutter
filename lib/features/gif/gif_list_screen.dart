import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_view/gif_view.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nil/nil.dart';
import 'package:test_flutter/features/gif/bloc/gif_bloc.dart';
import 'package:test_flutter/features/gif/bloc/gif_event.dart';
import 'package:test_flutter/features/gif/bloc/gif_state.dart';
import 'package:test_flutter/features/gif/gif_repository.dart';

import 'entity/gif_ui.dart';

class GifListScreen extends StatefulWidget {
  const GifListScreen({super.key});

  @override
  State<GifListScreen> createState() => _GifListScreenState();
}

class _GifListScreenState extends State<GifListScreen> {
  late GifBloc _bloc;
  late final _pagingController = PagingController<int, GifUI>(firstPageKey: 0);
  final TextEditingController _textController = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(title: const Text("List Gif")),
      body: SafeArea(
        child: Column(
          children: [
            BlocListener<GifBloc, GifState>(
              listener: (context, state) {
                if (state is GifErrorState) {
                  _pagingController.value = PagingState(
                    nextPageKey: 0,
                    error: null,
                    itemList: List.empty(),
                  );
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Error'),
                      content: Text(state.error),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('ОК'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Expanded(
                child: BlocBuilder<GifBloc, GifState>(
                  builder: (context, state) {
                    if (state is GifSuccessResponseState) {
                      if (state.isLastPage) {
                        _pagingController.appendLastPage(state.listGif);
                      } else {
                        _pagingController.appendPage(
                          state.listGif,
                          state.nextKey,
                        );
                      }
                    }
                    return Column(
                      children: [
                        Expanded(child: MyGridView()),
                        if (state is GifLoadingState)
                          Center(child: CircularProgressIndicator()),
                      ],
                    );
                  },
                ),
              ),
            ),
            MyInput(_bloc),
          ],
        ),
      ),
    );
  }

  Widget MyInput(GifBloc bloc) {
    return Container(
      margin: EdgeInsets.all(30),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(),
        ),
        onChanged: (text) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            _pagingController.value = PagingState(
              //Очистка предыдущих данных списка
              nextPageKey: 0,
              error: null,
              itemList: List.empty(),
            );
            _bloc.add(GifNewSearchEvent(text));
          });
        },
      ),
    );
  }

  Widget MyGridView() {
    return PagedGridView<int, GifUI>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) {
          return GestureDetector(
            onTap: () {
              _bloc.add(ItemClickEvent(item));
            },
            child: Column(
              children: [
                Expanded(child: GifView.network(item.previewUrl ?? "")),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(item.title ?? "", textAlign: TextAlign.center),
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
          );
        },
        newPageProgressIndicatorBuilder: (context) {
          return nil;
        },
        firstPageProgressIndicatorBuilder: (context) {
          return nil;
        },
        firstPageErrorIndicatorBuilder: (context) {
          return nil;
        },
        noItemsFoundIndicatorBuilder: (context) {
          return nil;
        },
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 2,
      ),
    );
  }
}
