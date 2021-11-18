import 'package:flutter/material.dart';

class TextParagraphCPNT extends StatelessWidget {
  VoidCallback  ?onPressed;
  Color colorText;
  String text;
  FontWeight ? fontWeight;
  TextParagraphCPNT({Key? key, this.onPressed,required this.colorText,required this.text,this.fontWeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child: Text(text,style: TextStyle(color: colorText,fontSize: 14,fontWeight: fontWeight),),

      );
  }
}

