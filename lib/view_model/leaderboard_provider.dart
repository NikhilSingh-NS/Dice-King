import 'package:dice_app/model/user_stats.dart';
import 'package:dice_app/service/api_interface.dart';
import 'package:dice_app/utils/constants.dart';
import 'package:dice_app/utils/dependency_assembly.dart';
import 'package:dice_app/utils/shared_preference_interface.dart';
import 'package:dice_app/view_model/base_model.dart';

class LeaderBoardProvider extends BaseModel {
  APIInterface _apiInterface = dependencyAssembler<APIInterface>();
  SharedPreferenceInterface _sharedPreferenceInterface =
      dependencyAssembler<SharedPreferenceInterface>();
  List<UserStats> userStatsList = [];

  String currentUserName = '';

  bool isReady = false;

  void setUserStatsList() {
    _apiInterface.getAllUserStats().then((Map<String, dynamic> result) async {
      if (result['status'] == NETWORK_STATUS.SUCCESS) {
        List<Map<String, dynamic>> userStatsFromApi = result['all_user_stats'];
        userStatsFromApi.forEach((Map<String, dynamic> stat) {
          userStatsList.add(UserStats.fromJson(stat));
        });
        userStatsList.sort((stat1, stat2) {
          return stat2.totalScore - stat1.totalScore;
        });
        currentUserName =
            await _sharedPreferenceInterface.getString(LOGGED_IN_USER_NAME);
      }
      networkState = result['status'];
      isReady = true;
      notifyListeners();
    });
  }
}
