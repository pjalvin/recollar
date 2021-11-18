import 'package:flutter/material.dart';
import 'package:recollar/general_widgets/text_paragraph_cpnt.dart';
import 'package:recollar/util/configuration.dart';

class TypeInformation extends StatelessWidget {
  final Size size;
  const TypeInformation({Key? key,required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      decoration: BoxDecoration(
          color: colorWhite,
        borderRadius: BorderRadius.circular(size.height*0.2),
      ),
      width: size.width,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Icon(Icons.circle,color: color1,size: 5,),
                TextParagraphCPNT(colorText: color1, text: " Venta",fontWeight: FontWeight.w600,)
              ],
            ),
            Row(
              children: [
                Icon(Icons.circle,color: maskcolor2,size: 5,),
                TextParagraphCPNT(colorText: maskcolor2, text: " Intercambio",fontWeight: FontWeight.w600)
              ],
            )
          ],
        ),
      )
    );
  }
}
