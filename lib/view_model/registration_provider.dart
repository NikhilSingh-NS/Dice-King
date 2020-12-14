import 'package:dice_app/service/api_interface.dart';
import 'package:dice_app/utils/constants.dart';
import 'package:dice_app/utils/dependency_assembly.dart';
import 'package:dice_app/view_model/base_model.dart';

class RegistrationProvider extends BaseModel {
  APIInterface _apiInterface = dependencyAssembler<APIInterface>();

  bool isUserAlreadyExists = false;

  Future<bool> trySignUp(String username, String name, String password) async {
    applyState(ViewState.Busy);
    notifyListeners();

    Map<String, dynamic> result =
        await _apiInterface.registerUser(username, name, password);
    networkState = result['status'];

    applyState(ViewState.Idle);
    notifyListeners();

    if (networkState == NETWORK_STATUS.SUCCESS)
      return true;
    else if (networkState == NETWORK_STATUS.FAILURE)
      isUserAlreadyExists = result['is_exists'];
    return false;
  }
}
