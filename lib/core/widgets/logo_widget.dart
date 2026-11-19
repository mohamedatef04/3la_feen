import 'package:ala_feen/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, this.height});
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.icons.logo_svg,
      height: height,
    );
  }
}
