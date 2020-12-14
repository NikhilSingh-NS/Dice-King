import 'package:flutter/material.dart';

class CircularWidget extends StatelessWidget {
  const CircularWidget(
      {this.width,
      this.height,
      this.topPadding,
      this.child,
      this.borderColor = const Color(0xFF284E91),
      this.borderColorEnd,
      this.boxShadow,
      this.borderStrokeWidth});

  final double width, height, topPadding;
  final Widget child;
  final Color borderColor, borderColorEnd;
  final List<BoxShadow> boxShadow;
  final double borderStrokeWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: boxShadow,
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
            color: borderColor, width: borderStrokeWidth ?? height * 0.0625),
      ),
      child: ClipOval(
          child: Container(
        color: Colors.white,
        height: height,
        width: width,
        child: child,
      )),
    );
  }
}
