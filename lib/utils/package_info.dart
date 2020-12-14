import 'package:dice_app/utils/package_info_interface.dart';
import 'package:package_info/package_info.dart';

class PackageInfoImpl implements PackageInfoInterface{

  @override
  Future<String> getAppVersion() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

}