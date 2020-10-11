import 'package:flutter/cupertino.dart';

class DeviceHelper {

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static EdgeInsets safeAreaInsets;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    safeAreaInsets = _mediaQueryData.viewPadding;
  }
}