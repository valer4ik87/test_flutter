import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:gif_view/gif_view.dart';
import 'package:test_flutter/features/gif/bloc/gif_bloc.dart';
import 'package:test_flutter/features/gif/bloc/gif_event.dart';
import 'package:test_flutter/features/gif/entity/gif_ui.dart';

class GifDetailsScreen extends StatelessWidget {
  final GifUI? gif;

  const GifDetailsScreen({super.key, required this.gif});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GifBloc>();
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(gif?.title ?? ""),
        leading: PlatformIconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => bloc.add(BackClickEvent()),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Expanded(child: GifView.network(gif?.originalUrl ?? "",errorBuilder: (context, error, tryAgain) {
                  return const Center(child: Text('Something wrong'));
                },)),
                PlatformElevatedButton(
                  onPressed: () => bloc.add(BackClickEvent()),
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
