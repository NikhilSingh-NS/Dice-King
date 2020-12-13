import 'dart:async';

import 'package:dice_app/ui/utils/size_config.dart';
import 'package:dice_app/ui/widgets/image_loader.dart';
import 'package:dice_app/utils/dependency_assembly.dart';
import 'package:dice_app/view_model/splash_provider.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<StatefulWidget> {
  final int milliseconds = 2000;
  final SplashProvider splashProvider = dependencyAssembler<SplashProvider>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Timer(Duration(milliseconds: milliseconds), () {
              takeRoutingDecisions();
            }));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Hero(
            tag: 'logo', child: ImageLoader().loadFromAssets('logo.png')),
      ),
    );
  }

  Future<void> takeRoutingDecisions() async {
    await splashProvider.takeRoutingDecision();
    if (splashProvider.screen == SCREEN.LOGIN_SCREEN)
      Routes().navigateWithReplace(LOGIN_SCREEN);
    else
      Routes().navigateWithReplace(HOME_SCREEN);
  }
}
