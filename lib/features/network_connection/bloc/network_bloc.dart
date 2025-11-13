import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'network_event.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  NetworkBloc() : super(NetworkInitial()) {
    on<CheckNetwork>((event, emit) async {
      final results = await Connectivity().checkConnectivity();
      if (results.contains(ConnectivityResult.none)) {
        emit(NetworkOffline());
      } else {
        emit(NetworkOnline());
      }
    });

    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.none)) {
        emit(NetworkOffline());
      } else {
        emit(NetworkOnline());
      }
    });

    // Проверка при запуске
    add(CheckNetwork());
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}