import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService() : _connectivity = Connectivity() {
    _initialize();
  }

  final Connectivity _connectivity;
  final _connectivityController = StreamController<bool>.broadcast();
  bool _isConnected = true;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<bool> get connectivityStream => _connectivityController.stream;

  bool get isConnected => _isConnected;

  void _initialize() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );

    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final hasConnection = results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );

    if (_isConnected != hasConnection) {
      _isConnected = hasConnection;
      _connectivityController.add(_isConnected);
    }
  }

  void dispose() {
    _subscription?.cancel();
    _connectivityController.close();
  }
}
