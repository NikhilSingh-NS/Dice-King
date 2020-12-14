import 'package:dice_app/utils/package_info.dart';

abstract class PackageInfoInterface {
  factory PackageInfoInterface() {
    return PackageInfoImpl();
  }

  Future<String> getAppVersion();
}
