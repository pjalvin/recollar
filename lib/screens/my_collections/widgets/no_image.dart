import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recollar/general_widgets/text_subtitle_cpnt.dart';
import 'package:recollar/util/configuration.dart';
class NoImage extends StatelessWidget {
  Size size;
  NoImage({Key? key,required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color:colorWhite,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, color: color2,),
            TextSubtitleCPNT(colorText: color2, text: "Agregar imagen", weight: FontWeight.w600)
          ],
        ),
      ),
    );
  }

}
