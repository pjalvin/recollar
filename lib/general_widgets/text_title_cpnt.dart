import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextTitleCPNT extends StatelessWidget {
  VoidCallback  ? onPressed;
  Color colorText;
  String text;
  FontWeight weight;
  int ?maxLines=1;
  TextTitleCPNT({Key? key,this.onPressed,required this.colorText,required this.text,required this.weight,this.maxLines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child: Text(text,style: TextStyle(color: colorText,fontSize: 25,fontWeight: weight,),maxLines: maxLines,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),

    );
  }
}

