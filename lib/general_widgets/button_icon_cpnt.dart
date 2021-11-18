
import 'package:flutter/material.dart';
class ButtonIconCPNT extends StatelessWidget {
  ImageProvider  ?image;
  IconData ?icon;
  VoidCallback  ? onPressed;
  Size size;
  Color ?color;
  ButtonIconCPNT.image({Key? key,required this.image,required this.onPressed, required this.size}) : super(key: key);
  ButtonIconCPNT.icon({Key? key,required this.onPressed, required this.size ,required this.icon, required this.color,this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  IconButton(
      padding: EdgeInsets.zero,
      icon: image!=null?Image(image:image??const AssetImage("assets/icons/fb.png"),width: size.width,height: size.height,):Icon(icon,size: size.width,),
      onPressed: onPressed,
      color: color,

    );
  }
}

