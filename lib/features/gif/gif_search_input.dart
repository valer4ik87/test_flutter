import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'bloc/gif_bloc.dart';
import 'bloc/gif_event.dart';
import 'entity/gif_ui.dart';

class GifSearchInput extends StatefulWidget {
  final PagingController<int, GifUI> pagingController;
  final PageRequestListener pageRequestListener;

  const GifSearchInput(
      {super.key,
      required this.pagingController,
      required this.pageRequestListener});

  @override
  State<GifSearchInput> createState() => _GifSearchInputState();
}

class _GifSearchInputState extends State<GifSearchInput> {
  Timer? debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: PlatformTextField(
        material: (_, __) => MaterialTextFieldData(
          decoration: const InputDecoration(
            labelText: 'Search',
            border: OutlineInputBorder(),
          ),
        ),
        cupertino: (_, __) => CupertinoTextFieldData(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
        ),
        onChanged: (text) {
          debounce?.cancel();
          debounce = Timer(const Duration(milliseconds: 500), () {
            if (!mounted) return;
            widget.pagingController
                .removePageRequestListener(widget.pageRequestListener);
            widget.pagingController.refresh();
            context.read<GifBloc>().add(GifNewSearchEvent(text));
            widget.pagingController
                .addPageRequestListener(widget.pageRequestListener);
          });
        },
      ),
    );
  }
}
