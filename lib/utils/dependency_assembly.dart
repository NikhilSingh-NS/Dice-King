import 'package:dice_app/service/api_interface.dart';
import 'package:dice_app/utils/package_info_interface.dart';
import 'package:dice_app/view_model/leaderboard_provider.dart';
import 'package:dice_app/view_model/registration_provider.dart';
import 'package:dice_app/view_model/splash_provider.dart';
import 'package:get_it/get_it.dart';
import 'shared_preference_interface.dart';
import 'package:dice_app/view_model/login_provider.dart';
import 'package:dice_app/utils/connectivity_interface.dart';
import 'package:dice_app/view_model/home_provider.dart';

GetIt dependencyAssembler = GetIt.instance;

void setUpDependencyAssembly(){
  dependencyAssembler.registerLazySingleton(() => SharedPreferenceInterface());
  dependencyAssembler.registerLazySingleton(() => APIInterface());
  dependencyAssembler.registerLazySingleton(() => ConnectivityInterface());
  dependencyAssembler.registerLazySingleton(() => PackageInfoInterface());
  dependencyAssembler.registerFactory(() => LoginScreenProvider());
  dependencyAssembler.registerFactory(() => SplashProvider());
  dependencyAssembler.registerFactory(() => HomeScreenProvider());
  dependencyAssembler.registerFactory(() => LeaderBoardProvider());
  dependencyAssembler.registerFactory(() => RegistrationProvider());
}