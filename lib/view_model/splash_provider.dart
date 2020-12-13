import 'package:dice_app/utils/dependency_assembly.dart';
import 'package:dice_app/utils/shared_preference_interface.dart';
import 'package:dice_app/view_model/base_model.dart';

enum SCREEN { LOGIN_SCREEN, HOME_SCREEN }

class SplashProvider extends BaseModel {
  SCREEN screen;

  Future<void> takeRoutingDecision() async {
    SharedPreferenceInterface sharedPreferenceInterface =
        dependencyAssembler<SharedPreferenceInterface>();
    String username =
        await sharedPreferenceInterface.getString(LOGGED_IN_USER_NAME);
    if (username != null && username.isNotEmpty)
      screen = SCREEN.HOME_SCREEN;
    else
      screen = SCREEN.LOGIN_SCREEN;
  }
}
