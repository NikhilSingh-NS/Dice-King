import 'package:dice_app/utils/constants.dart';

import 'api.dart';

abstract class APIInterface {
  factory APIInterface() {
    return API();
  }

  Future<NETWORK_STATUS> checkLoginUser(String username, String password);

  Future<Map<String, dynamic>> getUserStats(String username);

  Future<Map<String, dynamic>> getAllUserStats();

  Future<NETWORK_STATUS> updateStats(String username, Map<String, dynamic> map);

  Future<Map<String, dynamic>> registerUser(String username, String name, String password);

}
