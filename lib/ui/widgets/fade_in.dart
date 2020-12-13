import 'package:flutter/material.dart';

class FadeTransitionRoute extends PageRouteBuilder<dynamic> {
  FadeTransitionRoute({this.widget, this.routeSettings})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return widget;
      },
      settings: routeSettings,
      transitionsBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      });

  final Widget widget;
  final RouteSettings routeSettings;
}
