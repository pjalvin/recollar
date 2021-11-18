import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recollar/bloc/my_objects_bloc.dart';
import 'package:recollar/general_widgets/button_primary_cpnt.dart';
import 'package:recollar/general_widgets/loading_cpnt.dart';
import 'package:recollar/general_widgets/text_subtitle_cpnt.dart';
import 'package:recollar/screens/my_collections/widgets/no_image.dart';
import 'package:recollar/state/my_objects_state.dart';
import 'package:recollar/util/configuration.dart';

class PreviewAR extends StatefulWidget {
  PreviewAR({Key? key}) : super(key: key);

  @override
  State<PreviewAR> createState() => _PreviewARState();
}

class _PreviewARState extends State<PreviewAR> {
  Size sizeP=const Size(1,1);

  XFile ? image;

  @override
  Widget build(BuildContext context) {
    sizeP=MediaQuery.of(context).size;
    return BlocBuilder<MyObjectsBloc,MyObjectsState>(

      builder: (context,state) {
        return Scaffold(
          body: Stack(
            children: [
              SizedBox(
                width: sizeP.width,
                height: sizeP.height,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      state.imageAR!=null?Image.memory(state.imageAR!,height: sizeP.width*0.7,width: sizeP.width*0.7):NoImage(size:Size(sizeP.width*0.7,sizeP.width*0.7)),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextSubtitleCPNT(colorText: color2, text: "Esta la imagen correcta?", weight: FontWeight.w600)
                        ],
                      ),const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          ButtonPrimaryCPNT(
                              onPressed: (){
                                Navigator.pop(context,false);
                              },
                              size: Size(sizeP.width*0.4,50),
                              colorBg: color2,
                              colorText: colorWhite,
                              text: "Cancelar",

                              elevation: 0),

                          ButtonPrimaryCPNT(
                              onPressed: (){
                                Navigator.pop(context,state.imageAR);
                              },
                              size: Size(sizeP.width*0.4,50),
                              colorBg: color1,
                              colorText: color2,
                              text: "Aceptar",

                              elevation: 0)
                        ],
                      )
                    ],
                  )
              ),
              state is MyObjectsRemoveBgLoading?Positioned(bottom: 10,child: TextSubtitleCPNT(colorText: colorWhite, text: "Procesando Imagen ...", weight: FontWeight.w600)):Container(),
              state is MyObjectsRemoveBgLoading?LoadingCPNT(size: sizeP):Container()
            ],
          ),
        );
      }
    );
  }

}
