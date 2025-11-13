import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_flutter/features/gif/bloc/gif_event.dart';
import 'package:test_flutter/features/gif/bloc/gif_state.dart';
import 'package:test_flutter/features/gif/entity/gif_ui.dart';
import 'package:test_flutter/features/gif/gif_details_screen.dart';
import 'package:test_flutter/features/gif/gif_list_screen.dart';

import '../features/gif/bloc/gif_bloc.dart';


class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  final HOME = '/';
  final DETAILS = '/details';
  late final GoRouter router;
  GifUI? selectedItem;


  AppRouter(GifBloc bloc) {
    router = GoRouter(
      routes: [
        GoRoute(
          path: HOME,
          builder: (context, state) => BlocListener<GifBloc, GifState>(
            listener: (context, state) {
              if (state is ItemClickedState) {
                context.push(
                  DETAILS,
                  extra: state.gifUI,
                );
              } else if (state is BackClickState) {
                if (GoRouter.of(context).canPop()) {
                  context.pop();

                }
              }
            },
            child: GifListScreen(),
          ),
        ),
        GoRoute(
          path: DETAILS,
          pageBuilder: (context, state) {
            final gif = state.extra as GifUI?;
            return MaterialPage(child: GifDetailsScreen(gif: gif));
          },
        ),
      ],
    );
  }
}