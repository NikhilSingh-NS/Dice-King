import 'package:dice_app/service/api_interface.dart';
import 'package:dice_app/utils/constants.dart';
import 'package:dice_app/utils/dependency_assembly.dart';
import 'package:dice_app/utils/shared_preference_interface.dart';
import 'package:dice_app/view_model/base_model.dart';

class LoginScreenProvider extends BaseModel {
  APIInterface api = dependencyAssembler<APIInterface>();
  SharedPreferenceInterface sharedPreferenceInterface =
      dependencyAssembler<SharedPreferenceInterface>();

  Future<bool> tryLoggingIn(String username, String password) async {
    networkState = await api.checkLoginUser(username, password);
    //success...
    if (networkState == NETWORK_STATUS.SUCCESS) {
      await sharedPreferenceInterface.setString(LOGGED_IN_USER_NAME, username);
      return true;
    }
    return false;
  }
}
