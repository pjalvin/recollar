// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recollar/general_widgets/text_paragraph_cpnt.dart';
import 'package:recollar/general_widgets/text_subtitle_cpnt.dart';
import 'package:recollar/util/configuration.dart';

class SimpleCardCPNT extends StatelessWidget {

  VoidCallback  ?onPressed;
  Color color;
  Color colorBg;
  Color textColor;
  Color firstColor;
  Color secondColor;
  Size size;
  String text;
  String text2;
  String image;
  String token;
  String imagePath;
  BoxFit ? box;
  Color ? borderColor;
  final List<Color> _colors=[color2,maskcolor2,maskcolor1];
  SimpleCardCPNT({Key? key,this.borderColor,this.box,required this.imagePath,required this.token,required this.image,required this.color,required this.colorBg,required this.text2,required this.firstColor,required this.secondColor,required this.text,required this.textColor,this.onPressed,required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: ShaderMask(
            blendMode: BlendMode.color,
            shaderCallback: (Rect bounds) => LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                this.firstColor,
                this.secondColor,
              ],
            ).createShader(bounds),
            child: Container(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(box==BoxFit.contain?size.width*0.15:0),

                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                        image: DecorationImage(
                          image: AssetImage("assets/background/ar_bg.jpg"),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(_colors[Random().nextInt(_colors.length)], BlendMode.color,)
                        ),


                      ),
                      width: size.width,
                      height: size.height*0.6-2,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                        child: Image.network("http://"+(dotenv.env['API_URL'] ?? "")+"${dotenv.env['API_URL_COMP'] ?? ""}/image/"+image,headers: {"Authorization":"Bearer $token"},fit: box)
                        ,
                      )   ),
                  ),
                  Container(
                      width: size.width,
                      padding: EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.width*0.01),
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20) ,bottomRight: Radius.circular(20)),
                        //#D4D4D5
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextSubtitleCPNT(text: text,colorText: textColor,weight: FontWeight.w400,maxlines: 1,),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 7),
                                  child: TextParagraphCPNT(text: text2,colorText: textColor.withOpacity(0.5), onPressed: () {  },fontWeight: FontWeight.w600,),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        ),
    onTap: onPressed
   );
  }
}
