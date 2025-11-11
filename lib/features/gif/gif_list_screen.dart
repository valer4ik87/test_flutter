import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nil/nil.dart';
import 'package:test_flutter/features/gif/bloc/gif_bloc.dart';
import 'package:test_flutter/features/gif/bloc/gif_event.dart';
import 'package:test_flutter/features/gif/bloc/gif_state.dart';

import 'entity/gif_ui.dart';

class GifListScreen extends StatelessWidget  {
  const GifListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GifBloc>();
    bloc.pagingController.fetchNextPage();
    return Scaffold(
      appBar: AppBar(title: const Text("List Gif")),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search',
              border: OutlineInputBorder(),
            ),
            onChanged: (text) => bloc.add(GifSearchEvent(text)),
          ),
          Expanded(
            child: PagedGridView(
              state: bloc.pagingController.value,
              fetchNextPage: bloc.pagingController.fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate<GifUI>(
                itemBuilder: (BuildContext context, GifUI item, int index) {
                  return GestureDetector(
                    child: Text(item.title ?? ""),
                    onTap: () {
                      bloc.add(ItemClick());
                    },
                  );
                },
                firstPageProgressIndicatorBuilder: (_) =>
                const Center(child: CircularProgressIndicator()),
                newPageProgressIndicatorBuilder: (_) =>
                const Center(child: CircularProgressIndicator()),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
            ),
          ),
          BlocBuilder<GifBloc, GifState>(
            builder: (context, state) {
              if (state is GifLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GifError) {
                var errorText = state.error;
                return Dialog(child: Text(errorText),);
              } else if (state is GifSuccessResponse) {
                return nil;
              } else {
                return nil;
              }
            },
          ),
        ],
      ),
    );
  }
}
