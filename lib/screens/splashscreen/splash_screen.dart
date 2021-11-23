import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recollar/util/configuration.dart';

class SplashScreen  extends StatefulWidget{
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/square_logo_black.png',height: 200,),
            SizedBox(
              height: 100,
            ),
            SpinKitFadingCube(
                color: color2,
                size: 30
            ) ,
          ],
        ),
      ),
    );
  }
}