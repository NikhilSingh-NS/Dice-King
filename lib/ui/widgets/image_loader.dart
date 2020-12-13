import 'package:flutter/material.dart';

class ImageLoader {
  Widget load(String source, {BoxFit boxFit = BoxFit.fill}) {
    return Image.network(source, fit: boxFit);
  }

  Widget loadWithWidthHeight(String source,
      {BoxFit boxFit = BoxFit.fill, double width, double height}) {
    return Image.network(source, fit: boxFit, width: width, height: height);
  }

  Widget loadFromAssets(String source,
      {String prefix = 'assets/icons/',
      double width = double.infinity,
      double height = double.infinity}) {
    return Image.asset(
      '$prefix$source',
      width: width,
      height: height,
    );
  }
}
