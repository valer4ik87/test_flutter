import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  initState() {
    super.initState();
    _bloc = context.read<GifBloc>();
  }

  late final _pagingController = PagingController<int, GifUI>(
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) => _bloc.gifRepository.searchGif(
      _bloc.searchString,
      _bloc.limit,
      _bloc.limit * pageKey,
    ),
  );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GifBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text("List Gif")),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search',
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              setState(() {
                bloc.searchString = text;
                _pagingController.refresh();
              });
            },
          ),
          Expanded(
            child: PagingListener(
              controller: _pagingController,
              builder: (context, state, fetchNextPage) {
                return PagedGridView<int, GifUI>(
                  state: state,
                  fetchNextPage: fetchNextPage,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, item, index) {
                      return Text(item.title ?? "");
                    },
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
