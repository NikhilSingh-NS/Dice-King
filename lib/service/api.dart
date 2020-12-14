import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_app/service/api_interface.dart';
import 'package:dice_app/utils/connectivity_interface.dart';
import 'package:dice_app/utils/constants.dart';
import 'package:dice_app/utils/dependency_assembly.dart';

class API implements APIInterface {
  ConnectivityInterface connectivityInterface =
      dependencyAssembler<ConnectivityInterface>();

  @override
  Future<Map<String, dynamic>> getUserStats(String username) async {
    bool isConnected = await connectivityInterface.isInternetConnected();
    if (isConnected) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(userStatsCollection)
          .where('username', isEqualTo: username.trim().toLowerCase())
          .get();
      return querySnapshot.docs.length == 1
          ? <String, dynamic>{
              'status': NETWORK_STATUS.SUCCESS,
              'user_stats': querySnapshot.docs[0].data()
            }
          : <String, dynamic>{'status': NETWORK_STATUS.FAILURE};
    } else {
      return <String, dynamic>{'status': NETWORK_STATUS.NO_INTERNET};
    }
  }

  @override
  Future<Map<String, dynamic>> getAllUserStats() async {
    bool isConnected = await connectivityInterface.isInternetConnected();
    List<Map<String, dynamic>> result = [];
    if (isConnected) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection(userStatsCollection)
            .where('attempt_left', isEqualTo: 0)
            .get();
        querySnapshot.docs.forEach((QueryDocumentSnapshot snapshot) {
          result.add(snapshot.data());
        });
        return <String, dynamic>{
          'status': NETWORK_STATUS.SUCCESS,
          'all_user_stats': result
        };
      } catch (e) {
        return <String, dynamic>{'status': NETWORK_STATUS.FAILURE};
      }
    } else {
      return <String, dynamic>{'status': NETWORK_STATUS.NO_INTERNET};
    }
  }

  @override
  Future<NETWORK_STATUS> checkLoginUser(
      String username, String password) async {
    bool isConnected = await connectivityInterface.isInternetConnected();
    if (isConnected) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(userCollection)
          .where('username', isEqualTo: username.trim().toLowerCase())
          .where('password', isEqualTo: password)
          .get();
      return querySnapshot.docs.length == 1
          ? NETWORK_STATUS.SUCCESS
          : NETWORK_STATUS.FAILURE;
    } else {
      return NETWORK_STATUS.NO_INTERNET;
    }
  }

  Future<NETWORK_STATUS> updateStats(
      String username, Map<String, dynamic> map) async {
    bool isConnected = await connectivityInterface.isInternetConnected();
    if (isConnected) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(userStatsCollection)
          .where('username', isEqualTo: username.trim().toLowerCase())
          .get();
      if (querySnapshot.docs.length == 1) {
        await querySnapshot.docs[0].reference.update(map);
        return NETWORK_STATUS.SUCCESS;
      } else {
        return NETWORK_STATUS.FAILURE;
      }
    } else {
      return NETWORK_STATUS.NO_INTERNET;
    }
  }

  @override
  Future<Map<String, dynamic>> registerUser(
      String username, String name, String password) async {
    bool isConnected = await connectivityInterface.isInternetConnected();
    if (isConnected) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(userCollection)
          .where('username', isEqualTo: username.trim().toLowerCase())
          .get();
      if (querySnapshot.docs.length == 1) {
        return {'status': NETWORK_STATUS.FAILURE, 'is_exists': true};
      } else {
        try {
          await FirebaseFirestore.instance
              .collection(userCollection)
              .add({'username': username.trim().toLowerCase(), 'name': name, 'password': password});
          await FirebaseFirestore.instance.collection(userStatsCollection).add({
            'username': username.trim().toLowerCase(),
            'name': name,
            'total_score': 0,
            'max_score_once': 0,
            'last_score': 0,
            'attempt_left': maxAttemptCount
          });
        } catch (Exception) {
          return {'status': NETWORK_STATUS.FAILURE, 'is_exists': false};
        }
        return {'status': NETWORK_STATUS.SUCCESS};
      }
    } else {
      return {'status': NETWORK_STATUS.NO_INTERNET};
    }
  }
}
