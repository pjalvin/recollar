import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recollar/general_widgets/button_primary_cpnt.dart';
import 'package:recollar/general_widgets/text_field_primary_cpnt.dart';
import 'package:recollar/general_widgets/text_subtitle_cpnt.dart';
import 'package:recollar/models/password_request.dart';
import 'package:recollar/util/configuration.dart';
import 'package:recollar/util/my_behavior.dart';

class ChangePassAlert extends StatefulWidget {
  ChangePassAlert({Key? key}) : super(key: key);

  @override
  State<ChangePassAlert> createState() => _ChangePassAlertState();
}

class _ChangePassAlertState extends State<ChangePassAlert> {
  Size sizeP= const Size(1,1);
  TextEditingController oldPassText=TextEditingController();
  TextEditingController newPassText=TextEditingController();
  @override
  Widget build(BuildContext context) {
    sizeP=MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: colorGray,
      title: TextSubtitleCPNT(colorText: color2, text: "Cambiar contraseña", weight: FontWeight.w600),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ButtonPrimaryCPNT(
                onPressed: (){
                Navigator.pop(context,null);
                },
                size: Size(sizeP.width*0.3,40),
                colorBg: errorcolor,
                colorText: colorWhite,
                text: "Cancelar",

                elevation: 0),
            ButtonPrimaryCPNT(
                onPressed: (){
                  PasswordRequest pass=PasswordRequest(oldPassText.text, newPassText.text);
                  Navigator.pop(context,pass);

                },
                size: Size(sizeP.width*0.3,40),
                colorBg: color2,
                colorText: colorWhite,
                text: "Aceptar",
                elevation: 0)
          ],
        )
      ],
      content: SizedBox(
        height: sizeP.height*0.3,
        width: sizeP.width,
        child: Center(
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal:sizeP.width*0.035),
                    child:
                    TextSubtitleCPNT(onPressed: (){}, colorText: color2.withOpacity(0.7), text: "Contraseña actual", weight: FontWeight.w200)

                ),
                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    TextFieldPrimaryCPNT(maxLength: 50,icon: null, textType: TextInputType.text, obscureText: true, controller: oldPassText, colorBorder: colorWhite, size: Size(sizeP.width*0.6,50), colorBg: colorWhite, colorText: color2, hintText: ""),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal:sizeP.width*0.035),
                    child:
                    TextSubtitleCPNT(onPressed: (){}, colorText: color2.withOpacity(0.7), text: "Nueva contraseña", weight: FontWeight.w200)

                ),
                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    TextFieldPrimaryCPNT(maxLength: 50,icon: null, textType: TextInputType.text, obscureText: true, controller: newPassText, colorBorder: colorWhite, size: Size(sizeP.width*0.6,50), colorBg: colorWhite, colorText: color2, hintText: ""),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
