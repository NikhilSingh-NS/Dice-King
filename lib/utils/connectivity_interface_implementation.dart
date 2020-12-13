import 'package:connectivity/connectivity.dart';
import 'connectivity_interface.dart';

class ConnectivityImpl implements ConnectivityInterface {
  @override
  Future<bool> isInternetConnected() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}
