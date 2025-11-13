import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:nil/nil.dart';
import 'package:test_flutter/features/gif/bloc/gif_bloc.dart';
import 'package:test_flutter/features/gif/gif_repository.dart';
import 'package:test_flutter/features/network_connection/bloc/network_bloc.dart';
import 'package:test_flutter/features/network_connection/network_overlay.dart';
import 'core/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final gifBloc = GifBloc(GifRepository());
  final networkBloc = NetworkBloc();
  final appRouter = AppRouter(gifBloc);
  runApp(
    MyApp(gifBloc: gifBloc, networkBloc: networkBloc, appRouter: appRouter),
  );
}

class MyApp extends StatelessWidget {
  final GifBloc gifBloc;
  final NetworkBloc networkBloc;
  final AppRouter appRouter;

  const MyApp({
    super.key,
    required this.gifBloc,
    required this.networkBloc,
    required this.appRouter,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: networkBloc),
        BlocProvider.value(value: gifBloc),
      ],
      child: PlatformApp.router(
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        routerConfig: appRouter.router,
        builder: (context, child) => Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => NetworkOverlay(child: child ?? nil),
            ),
          ],
        ),
      ),
    );
  }
}
