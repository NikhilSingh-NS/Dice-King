import 'dart:math';

import 'package:dice_app/model/user_stats.dart';
import 'package:dice_app/service/api_interface.dart';
import 'package:dice_app/service/dice_service.dart';
import 'package:dice_app/utils/constants.dart';
import 'package:dice_app/utils/dependency_assembly.dart';
import 'package:dice_app/utils/package_info_interface.dart';
import 'package:dice_app/utils/shared_preference_interface.dart';
import 'package:dice_app/view_model/base_model.dart';

class HomeScreenProvider extends BaseModel {
  APIInterface apiInterface = dependencyAssembler<APIInterface>();
  SharedPreferenceInterface sharedPreferenceInterface =
      dependencyAssembler<SharedPreferenceInterface>();
  PackageInfoInterface _packageInfoInterface =
      dependencyAssembler<PackageInfoInterface>();
  DiceService diceService = dependencyAssembler<DiceService>();

  UserStats userStats;

  bool isReady = false;

  String versionName = '';

  Future<bool> getUserStats() async {
    bool status = false;
    if (!isReady) {
      final String username =
          await sharedPreferenceInterface.getString(LOGGED_IN_USER_NAME);
      final Map<String, dynamic> result =
          await apiInterface.getUserStats(username);
      networkState = result['status'];
      if (result['status'] == NETWORK_STATUS.SUCCESS) {
        userStats = UserStats.fromJson(result['user_stats']);
        status = true;
      } else {
        status = false;
      }
      isReady = true;
      notifyListeners();
      setVersionName();
      return status;
    }
    return true;
  }

  void setVersionName() {
    _packageInfoInterface.getAppVersion().then((value) {
      versionName = value;
      notifyListeners();
    });
  }

  Future<void> logout() async {
    await sharedPreferenceInterface.setString(LOGGED_IN_USER_NAME, null);
  }

  Future<bool> rollTheDice() async {
    int temp = diceService.rollDice();
    int newScore = userStats.totalScore + temp;
    int attemptLeft = userStats.attemptLeft - 1;

    applyState(ViewState.Busy);
    notifyListeners();

    networkState = await apiInterface.updateStats(userStats.username, {
      'attempt_left': attemptLeft,
      'total_score': newScore,
      'last_score': temp,
      'max_score_once': temp > userStats.maxScore ? temp : userStats.maxScore
    });

    applyState(ViewState.Idle);

    if (networkState == NETWORK_STATUS.SUCCESS) {
      userStats.lastScore = temp;
      if (temp > userStats.maxScore) userStats.maxScore = temp;
      userStats.totalScore = newScore;
      userStats.attemptLeft = attemptLeft;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }
}
