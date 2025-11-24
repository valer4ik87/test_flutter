import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_flutter/features/gif/bloc/gif_state.dart';
import 'package:test_flutter/features/gif/entity/gif_ui.dart';
import 'package:test_flutter/features/gif/gif_details_screen.dart';
import 'package:test_flutter/features/gif/gif_list_screen.dart';

import '../features/gif/bloc/gif_bloc.dart';

class AppRouter {
  static const String home = '/';
  static const String details = '/details';
  late final GoRouter router;
  GifUI? selectedItem;

  AppRouter(GifBloc bloc) {
    router = GoRouter(
      routes: [
        GoRoute(path: home, builder: (context, state) => const GifListScreen()),
        GoRoute(
          path: details,
          pageBuilder: (context, state) {
            final gif = state.extra as GifUI?;
            return MaterialPage(child: GifDetailsScreen(gif: gif));
          },
        ),
      ],
    );

    bloc.stream.where((state) {
      return state is ItemClickedState || state is BackClickState;
    }).listen((state) {
      final context = router.routerDelegate.navigatorKey.currentContext;
      if (context == null) return;

      if (state is ItemClickedState) {
        if (context.mounted) {
          context.push(details, extra: state.gifUI);
        }
      } else if (state is BackClickState) {
        if (context.mounted && context.canPop()) {
          context.pop();
        }
      }
    });
  }
}
