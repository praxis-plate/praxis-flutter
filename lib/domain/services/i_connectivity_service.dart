abstract interface class IConnectivityService {
  bool get isConnected;
  Stream<bool> get connectivityStream;
}
