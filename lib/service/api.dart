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
          .where('username', isEqualTo: username)
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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(userStatsCollection)
          .get();
      if (querySnapshot.docs.length > 0) {
        querySnapshot.docs.forEach((QueryDocumentSnapshot snapshot) {
          result.add(snapshot.data());
        });
        return <String, dynamic>{
          'status': NETWORK_STATUS.SUCCESS,
          'all_user_stats': result
        };
      } else
        return <String, dynamic>{'status': NETWORK_STATUS.FAILURE};
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
          .where('username', isEqualTo: username)
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
          .where('username', isEqualTo: username)
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
}
