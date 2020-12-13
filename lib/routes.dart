import 'package:dice_app/ui/view/home_screen.dart';
import 'package:dice_app/ui/view/leaderboard_screen.dart';
import 'package:dice_app/ui/view/login_screen.dart';
import 'package:dice_app/ui/view/registration_screen.dart';
import 'package:dice_app/ui/view/splash_screen.dart';
import 'package:dice_app/ui/widgets/fade_in.dart';
import 'package:dice_app/ui/widgets/scale_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TransitionType { SCALE_IN, FADE_IN }

const String SPLASH_SCREEN = 'splash_screen';
const String LOGIN_SCREEN = 'login_screen';
const String HOME_SCREEN = 'home_screen';
const String REGISTRATION_SCREEN = 'registration_screen';
const String LEADERBOARD_SCREEN = 'leaderboard_screen';

class Routes {
  factory Routes() {
    return _instance;
  }

  Routes._internal();

  static final Routes _instance = Routes._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Map<String, WidgetBuilder> map = <String, WidgetBuilder>{
    '/': (BuildContext context) {
      return SplashScreen();
    },
    LOGIN_SCREEN: (BuildContext context) {
      return LoginScreen();
    },
    HOME_SCREEN: (BuildContext context) {
      return HomeScreen();
    },
    REGISTRATION_SCREEN: (BuildContext context) {
      return RegistrationScreen();
    },
    LEADERBOARD_SCREEN: (BuildContext context) {
      return LeaderBoardScreen();
    }
  };

  Future<void> navigateWithReplace(String name,
      {Object arguments,
      bool pushNamedAndRemoveUntil = false,
      String lastScreen}) async {
    await SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
    if (pushNamedAndRemoveUntil) {
      if (lastScreen != null) {
        navigatorKey.currentState.pushNamedAndRemoveUntil(
            name, ModalRoute.withName(lastScreen),
            arguments: arguments);
      } else {
        navigatorKey.currentState.pushNamedAndRemoveUntil(
            name, (Route<dynamic> route) => false,
            arguments: arguments);
      }
    } else {
      navigatorKey.currentState
          .pushReplacementNamed(name, arguments: arguments);
    }
  }

  Future<dynamic> navigateTo(
    BuildContext context,
    String name, {
    bool withAnimation = false,
    TransitionType type,
    Object arguments,
  }) async {
    final Widget screen = map[name](context);
    final RouteSettings routeSettings =
        RouteSettings(name: name, arguments: arguments);

    //default only if with Animation
    PageRouteBuilder<dynamic> pageRouteBuilder =
        FadeTransitionRoute(widget: screen, routeSettings: routeSettings);

    switch (type) {
      case TransitionType.SCALE_IN:
        pageRouteBuilder =
            ScaleRoute(widget: screen, routeSettings: routeSettings);
        break;
      case TransitionType.FADE_IN:
        pageRouteBuilder =
            FadeTransitionRoute(widget: screen, routeSettings: routeSettings);
        break;
      default:
        pageRouteBuilder =
            FadeTransitionRoute(widget: screen, routeSettings: routeSettings);
    }

    await SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
    if (withAnimation)
      return await navigatorKey.currentState.push(pageRouteBuilder);
    else
      return await navigatorKey.currentState
          .pushNamed(name, arguments: arguments);
  }

  Future<bool> pop(dynamic data) async {
    await SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
    navigatorKey.currentState.pop<dynamic>(data);
    return true;
  }

  Widget getScreenWidgetFromName(BuildContext context, String name) {
    return map[name](context);
  }
}
