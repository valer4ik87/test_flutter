import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_view/gif_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'bloc/gif_bloc.dart';
import 'bloc/gif_event.dart';
import 'entity/gif_ui.dart';

class GifGridView extends StatelessWidget {
  final PagingController<int, GifUI> pagingController;

  const GifGridView({
    super.key,
    required this.pagingController,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GifBloc>();
    return PagedSliverGrid<int, GifUI>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) {
          return GestureDetector(
            onTap: () => bloc.add(ItemClickEvent(item)),
            child: Column(
              children: [
                Expanded(
                    child: GifView.network(
                  item.previewUrl ?? "",
                  errorBuilder: (context, error, tryAgain) {
                    return const Center(child: Text('Something wrong'));
                  },
                )),
                Text(item.title ?? "", textAlign: TextAlign.center),
                Text("Author: ${item.author}", textAlign: TextAlign.center),
              ],
            ),
          );
        },
        newPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
        firstPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
        firstPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 2,
      ),
    );
  }
}
