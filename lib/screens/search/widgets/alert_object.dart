import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recollar/bloc/search_bloc.dart';
import 'package:recollar/events/search_event.dart';
import 'package:recollar/general_widgets/button_icon_cpnt.dart';
import 'package:recollar/general_widgets/loading_cpnt.dart';
import 'package:recollar/general_widgets/text_paragraph_cpnt.dart';
import 'package:recollar/general_widgets/text_subtitle_cpnt.dart';
import 'package:recollar/general_widgets/text_title_cpnt.dart';
import 'package:recollar/screens/ar_visor/ar_visor.dart';
import 'package:recollar/state/search_state.dart';
import 'package:recollar/util/configuration.dart';


class AlertObject extends StatelessWidget{
  const AlertObject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context),

      ),
    );
  }

  dialogContent(BuildContext context){
    return BlocBuilder<SearchBloc,SearchState>(
        builder: (context,state) {
          if(state is SearchObjectOk && state.object!=null){
            return Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top:280,
                    bottom: 16,
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                      color: colorGray,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(17),
                      boxShadow: [
                        BoxShadow(
                          color: colorBlack,
                          blurRadius: 10.0,
                          offset: Offset(0.0,0.8),

                        )
                      ]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextTitleCPNT(colorText: color2, text: state.object!.name, weight: FontWeight.w700),
                      SizedBox(height: 16.0),
                      TextParagraphCPNT(onPressed: (){}, colorText: maskcolor1, text: state.object!.description),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              TextSubtitleCPNT(colorText: color2, text: "Estado", weight: FontWeight.w700),
                              SizedBox(height: 16.0),
                              Text("${state.object!.objectStatus}/10",
                                style: TextStyle(
                                    color: maskcolor1,
                                    fontSize: 16
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              TextSubtitleCPNT(colorText: color2, text: "Precio", weight: FontWeight.w700),
                              SizedBox(height: 16.0),
                              Text("${state.object!.price}",
                                style: TextStyle(
                                    color: maskcolor1,
                                    fontSize: 16
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),

                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 250,
                    padding: EdgeInsets.all(state.object!.ar?30:0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colorWhite,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image(
                        image: NetworkImage("http://"+(dotenv.env['API_URL'] ?? "")+"${dotenv.env['API_URL_COMP'] ?? ""}/image/"+state.object!.image,headers: {"Authorization":"Bearer ${state.object!.token}"}),
                        fit: state.object!.ar?BoxFit.contain:BoxFit.cover,

                      ),
                    )
                  ),
                ),
                state.object!.ar?Positioned(
                  top: 200,
                  right: 10,
                  child: ButtonIconCPNT.icon(onPressed: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ArVisor(image:state.object!.image,token:state.object!.token)));
                  }, size: Size(30,30), icon: Icons.visibility_sharp, color: color1)
                ):Positioned(
                    top: 200,
                    right: 10,
                    child: ButtonIconCPNT.icon(onPressed: (){}, size: Size(30,30), icon: Icons.visibility_sharp, color: Colors.transparent)
                )
              ],
            );
          }
          else{
            return SpinKitFadingCube(
                color: Colors.white,
                size: 30
            );
          }
        }
    );
  }
}