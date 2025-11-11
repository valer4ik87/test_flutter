import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter/features/gif/bloc/gif_bloc.dart';
import 'package:test_flutter/features/gif/gif_repository.dart';

import 'core/router.dart';

void main() {
  final appRouter = AppRouter();
  final gifBloc = GifBloc(GifRepository());
  runApp(MyApp(gifBloc: gifBloc, appRouter: appRouter));
}

class MyApp extends StatelessWidget {
  final GifBloc gifBloc;
  final AppRouter appRouter;
  const MyApp({super.key, required this.gifBloc, required this.appRouter});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return BlocProvider.value(
      value: gifBloc,
      child: MaterialApp.router(
        routerConfig: appRouter.router,
      ),
    );
  }
}
