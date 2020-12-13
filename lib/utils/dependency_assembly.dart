import 'package:dice_app/service/api_interface.dart';
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
  dependencyAssembler.registerFactory(() => LoginScreenProvider());
  dependencyAssembler.registerFactory(() => SplashProvider());
  dependencyAssembler.registerFactory(() => HomeScreenProvider());
}