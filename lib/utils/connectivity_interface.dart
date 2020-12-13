import 'connectivity_interface_implementation.dart';

abstract class ConnectivityInterface {
  factory ConnectivityInterface() {
    return ConnectivityImpl();
  }

  Future<bool> isInternetConnected();
}
