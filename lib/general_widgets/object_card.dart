import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recollar/general_widgets/text_paragraph_cpnt.dart';
import 'package:recollar/general_widgets/text_subtitle_cpnt.dart';
import 'package:recollar/util/configuration.dart';

class ObjectCard extends StatelessWidget {

  VoidCallback  ?onPressed;
  Color borderColor;
  Color textColor;
  Size size;
  String text;
  String image;
  String token;
  bool ar;


  ObjectCard({Key? key,required this.onPressed, required this.borderColor,required this.textColor,required this.ar,
     required this.size,required this.text,required this.image,required this.token/*,required this.imagePath*/}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.circular( size.width*0.05),
            image:DecorationImage(
                image: NetworkImage("http://"+(dotenv.env['API_URL'] ?? "")+"${dotenv.env['API_URL_COMP'] ?? ""}/image/"+image,headers: {"Authorization":"Bearer $token"}),
                fit: ar?BoxFit.contain:BoxFit.cover,
            ),
          ),
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  height: size.height*0.2,
                  width: size.width,
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
                  decoration: BoxDecoration(
                    color: color2,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(size.width*0.05) ,bottomRight: Radius.circular(size.width*0.05)),
                    //#D4D4D5
                  ),
                  child: Center(
                    child: SizedBox(
                              width: size.width,
                              child: TextSubtitleCPNT(text: text,colorText: textColor,weight: FontWeight.w400,maxlines: 2,),
                            ),
                  )
                  )

            ],
          ),
        ),
        onTap: onPressed
    );
  }
}
