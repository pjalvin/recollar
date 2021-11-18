import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recollar/bloc/my_objects_bloc.dart';
import 'package:recollar/events/my_objects_event.dart';
import 'package:recollar/general_widgets/loading_cpnt.dart';
import 'package:recollar/general_widgets/text_paragraph_cpnt.dart';
import 'package:recollar/general_widgets/text_subtitle_cpnt.dart';
import 'package:recollar/general_widgets/text_title_cpnt.dart';
import 'package:recollar/state/my_objects_state.dart';
import 'package:recollar/util/configuration.dart';


class DialogCard extends StatelessWidget{
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
    return BlocBuilder<MyObjectsBloc,MyObjectsState>(
      builder: (context,state) {
        if(state is MyObjectsGetObjectOk && state.object!=null){
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
                    color: colorWhite,
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
                    state.object!.status==1?Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ignore: deprecated_member_use
                        FlatButton(
                          onPressed: (){
                            context.read<MyObjectsBloc>().add(MyObjectsChangeStatus(state.object!.idObject, 2));
                            Navigator.pop(context);
                          },
                          child: Text("Intercambiar",
                            style: TextStyle(
                              color: colorWhite,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          color: maskcolor2,
                        ),
                        // ignore: deprecated_member_use
                        FlatButton(
                          onPressed: (){
                            context.read<MyObjectsBloc>().add(MyObjectsChangeStatus(state.object!.idObject, 3));
                            Navigator.pop(context);
                          },
                          child: Text("Vender",
                            style: TextStyle(
                              color: color2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          color: color1,
                        ),
                      ],
                    ):
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ignore: deprecated_member_use
                        FlatButton(
                          onPressed: (){
                            context.read<MyObjectsBloc>().add(MyObjectsChangeStatus(state.object!.idObject, 1));
                            Navigator.pop(context);
                          },
                          child: Text("Quitar de venta o intercambio",
                            style: TextStyle(
                              color: colorWhite,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          color: maskcolor2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: colorWhite,
                  ),
                  child: Image(
                    image: NetworkImage("http://"+(dotenv.env['API_URL'] ?? "")+"${dotenv.env['API_URL_COMP'] ?? ""}/image/"+state.object!.image,headers: {"Authorization":"Bearer ${state.object!.token}"}),
                    fit: state.object!.ar?BoxFit.contain:BoxFit.cover,

                  ),
                ),
              ),
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