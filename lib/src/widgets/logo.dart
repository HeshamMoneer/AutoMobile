import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget addLogo(double size, bool isBlack) {
  String color = isBlack ? 'black' : 'white';
  String assetLocation = 'assets/images/logo-$color.svg';
  return SvgPicture.asset(
    assetLocation,
    width: size,
    height: size,
  );
}
