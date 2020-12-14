import 'package:dice_app/model/user_stats.dart';
import 'package:dice_app/service/api_interface.dart';
import 'package:dice_app/service/dice_service.dart';
import 'package:dice_app/utils/constants.dart';
import 'package:dice_app/utils/dependency_assembly.dart';
import 'package:dice_app/view_model/home_provider.dart';
import 'package:test/test.dart';

//will only override the required update stats for now...
class APIMockSuccess implements APIInterface {
  @override
  Future<NETWORK_STATUS> checkLoginUser(String username, String password) {
    // TODO: implement checkLoginUser
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getAllUserStats() {
    // TODO: implement getAllUserStats
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getUserStats(String username) {
    // TODO: implement getUserStats
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> registerUser(
      String username, String name, String password) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }

  //imp. ..
  @override
  Future<NETWORK_STATUS> updateStats(
      String username, Map<String, dynamic> map) async {
    return NETWORK_STATUS.SUCCESS;
  }
}

//will only override the required update stats for now...
class APIMockFailure implements APIInterface {
  @override
  Future<NETWORK_STATUS> checkLoginUser(String username, String password) {
    // TODO: implement checkLoginUser
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getAllUserStats() {
    // TODO: implement getAllUserStats
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getUserStats(String username) {
    // TODO: implement getUserStats
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> registerUser(
      String username, String name, String password) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }

  //imp. ..
  @override
  Future<NETWORK_STATUS> updateStats(
      String username, Map<String, dynamic> map) async {
    return NETWORK_STATUS.FAILURE;
  }
}

//return 5 for mocking
class MockDiceService implements DiceService {
  @override
  int rollDice() {
    return 5;
  }
}

//mock user stats with 1 attempt with last score of 2...
UserStats userStatsMock = UserStats(
    username: 'test123',
    name: 'Test',
    totalScore: 2,
    attemptLeft: 9,
    maxScore: 2,
    lastScore: 2);

main() {
  setUpDependencyAssembly();
  HomeScreenProvider provider = dependencyAssembler<HomeScreenProvider>();
  provider.userStats = userStatsMock;
  provider.diceService = MockDiceService();

  group('Test Roll A Dice', () {
    test('Success Test', () async {
      provider.apiInterface = APIMockSuccess();
      await provider.rollTheDice();

      //stats should increase and attempt should decrease...
      expect(provider.userStats.attemptLeft, 8); // attempt decrease
      expect(provider.userStats.maxScore, 5); // max score set to 5
      expect(provider.userStats.totalScore, 7); // total score inc by 5
      expect(provider.userStats.lastScore, 5); // last score set to 5
    });
    test('Failure Test', () async{
      provider.apiInterface = APIMockFailure();
      await provider.rollTheDice();

      //stats should remain same as last success test after failure...
      expect(provider.userStats.attemptLeft, 8);
      expect(provider.userStats.maxScore, 5);
      expect(provider.userStats.totalScore, 7);
      expect(provider.userStats.lastScore, 5);
    });
  });
}
