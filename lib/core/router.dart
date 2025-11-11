import 'package:go_router/go_router.dart';
import 'package:test_flutter/features/gif/gif_details_screen.dart';
import 'package:test_flutter/features/gif/gif_list_screen.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => GifListScreen(),
        ),
        GoRoute(
          path: '/details:gif',
          builder: (context, state) => GifDetailsScreen(),
        ),
      ],
    );
  }
}