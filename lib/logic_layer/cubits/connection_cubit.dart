import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/logic_layer/states/connection_state.dart';

class ConnectionCubit extends Cubit<ConnectionStates> {
  final Connectivity connection;
  StreamSubscription connectionStream;

  ConnectionCubit({@required this.connection}) : super(Disconnected()) {
    connectionSetUp();
  }

  StreamSubscription<ConnectivityResult> connectionSetUp() {
    return connectionStream = connection.onConnectivityChanged.listen((status) {
      if (status == ConnectivityResult.wifi || status == ConnectivityResult.mobile) {
        emitConnected();
      } else if (status == ConnectivityResult.none) {
        emitDisconnected();
      }
    });
  }

  void emitConnected() => emit(Connected());

  void emitDisconnected() => emit(Disconnected());

  @override
  Future<void> close() {
    connectionStream.cancel();
    return super.close();
  }
}
