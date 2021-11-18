import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recollar/util/configuration.dart';

class LoadingCPNT extends StatelessWidget {
  LoadingCPNT({Key? key,required this.size}) : super(key: key);
  Size size;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: size.width,
        height: size.height,
      color: colorBlack.withOpacity(0.5),
      child:SpinKitFadingCube(
        color: Colors.white,
        size: size.width*0.08
      ) ,
    );
  }
}
