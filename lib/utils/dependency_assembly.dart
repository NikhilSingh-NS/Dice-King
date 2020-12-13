import 'package:get_it/get_it.dart';
import 'shared_preference_interface.dart';

GetIt dependencyAssembler = GetIt.instance;

void setUpDependencyAssembly(){
  dependencyAssembler.registerLazySingleton(() => SharedPreferenceInterface());
}