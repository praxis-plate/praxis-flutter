import 'dart:async';

import 'package:codium/domain/services/services.dart';

class MockConnectivityService implements IConnectivityService {
  final _connectivityController = StreamController<bool>.broadcast();

  @override
  bool get isConnected => true;

  @override
  Stream<bool> get connectivityStream => _connectivityController.stream;

  void dispose() {
    _connectivityController.close();
  }
}
