import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:gif_view/gif_view.dart';
import 'package:test_flutter/features/gif/bloc/gif_bloc.dart';
import 'package:test_flutter/features/gif/bloc/gif_event.dart';
import 'package:test_flutter/features/gif/bloc/gif_state.dart';
import 'package:test_flutter/features/gif/entity/gif_ui.dart';

class GifDetailsScreen extends StatelessWidget {
  final GifUI? gif;

  const GifDetailsScreen({super.key, required this.gif});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GifBloc>();
    bloc.emit(InitState());
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(gif?.title ?? ""),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => bloc.add(BackClickEvent()),
        ),
      ),
      body: SafeArea(
        child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Expanded(child: GifView.network(gif?.originalUrl ?? "")),
                PlatformElevatedButton(
                  onPressed: () => bloc.add(BackClickEvent()),
                  child: Text('Back'),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
