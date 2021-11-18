import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:recollar/bloc/my_objects_bloc.dart';
import 'package:recollar/events/my_objects_event.dart';
import 'package:recollar/general_widgets/button_icon_cpnt.dart';
import 'package:recollar/general_widgets/loading_cpnt.dart';
import 'package:recollar/general_widgets/text_paragraph_cpnt.dart';
import 'package:recollar/general_widgets/text_subtitle_cpnt.dart';
import 'package:recollar/models/object.dart';
import 'package:recollar/models/object_simple.dart';
import 'package:recollar/repositories/my_objects_repository.dart';
import 'package:recollar/screens/my_objects/widgets/object_form.dart';
import 'package:recollar/state/my_objects_state.dart';
import 'widgets/dialog_card.dart';
import 'package:recollar/general_widgets/object_card.dart';
import 'package:recollar/general_widgets/text_title_cpnt.dart';
import 'package:recollar/models/collection.dart';
import 'package:recollar/util/configuration.dart';


class MyObjects extends StatefulWidget{
  Collection col;
  MyObjects (this.col);
  @override
  _MyObjectsState createState() => _MyObjectsState();
}

class _MyObjectsState extends State<MyObjects>{
  Size sizeP=const Size(1,1);
  final ScrollController _scrollController=ScrollController();
  @override
  Widget build(BuildContext context){
    sizeP=MediaQuery.of(context).size;
    return BlocProvider(
        create: (context)=>MyObjectsBloc(MyObjectsRepository())..add(MyObjectsSetCollection(widget.col.idCollection))..add(MyObjectsInit()),
        child: BlocBuilder<MyObjectsBloc,MyObjectsState>(
          builder: (context,state) {
            return Scaffold(
              backgroundColor: colorGray,
              body: Stack(
                children: [
                  Container(
                    color: color2,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 110),
                    height: sizeP.height-110,
                    decoration: BoxDecoration(
                      borderRadius:  BorderRadius.only(topLeft: Radius.circular(sizeP.width*0.05),topRight: Radius.circular(sizeP.width*0.05)),
                      color: colorGray,
                    ),
                    child: Stack(
                      children: [
                        Center(
                            child: Opacity(
                              opacity: 0.1,
                              child: Image.asset("assets/square_logo_black.png",width: sizeP.width*0.6,height: 100,),
                            )
                        ),
                        ClipRRect(
                          borderRadius:  BorderRadius.only(topLeft: Radius.circular(sizeP.width*0.05),topRight: Radius.circular(sizeP.width*0.05)),
                          child: StaggeredGridView.extent(

                              controller:_scrollController,
                              shrinkWrap: true,

                              scrollDirection: Axis.vertical,

                              padding:EdgeInsets.only(left: 10 ,right: 10,top: 10,bottom: 50+sizeP.height*0.02),

                              children: getList(
                                  state.objects,context
                              ),
                              staggeredTiles: getListTile(
                                  state.objects
                              ),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              maxCrossAxisExtent: sizeP.width*0.5,
                            ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 110,
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top,left: sizeP.width*0.01,right: sizeP.width*0.05),
                    width: sizeP.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ButtonIconCPNT.icon(onPressed: (){
                                  Navigator.pop(context);
                                }, size: const Size(30,20),icon: Icons.arrow_back,color: colorWhite),
                                TextTitleCPNT(onPressed: (){}, colorText: colorWhite, text: widget.col.name,weight: FontWeight.w600,),
                              ],
                            ),
                            ButtonIconCPNT.icon(onPressed: (){
                              print("as");
                              addObject(context);
                            },
                            size: const Size(40,20),
                            icon: Icons.add_circle_outlined,
                            color: color1
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  state is MyObjectsLoading?LoadingCPNT(size:sizeP):Container()
                ],
              )
      );
          }
        ),
    );
  }

  List<Widget> getList(List<ObjectSimple> objectList,BuildContext context){
    print(objectList);
    List<Widget> list=[];
    var height=250.0;
    for(var i=0;i<objectList.length;i++){
      var obj=objectList[i];
      list.add(GestureDetector(
        onLongPress: (){
          context.read<MyObjectsBloc>().add(MyObjectsChangeTools(i));
        },
        onTap: (){
          context.read<MyObjectsBloc>().add(MyObjectsGetObject(obj.idObject));
          showDialog(context: context, builder: (_) => BlocProvider.value(value: BlocProvider.of<MyObjectsBloc>(context),child: DialogCard(),),
              barrierDismissible: true);
        },
        child:
        Stack(
            children: [
              ObjectCard(onPressed: (){
      },
        borderColor: color2.withOpacity(0.5),
        textColor: colorWhite,
        size: Size(sizeP.width, height),
        text: obj.name,
        image: obj.image,
        token: obj.token,
                ar: obj.ar,
        /*imagePath: imagePath*/),
              AnimatedOpacity(opacity: obj.tools?0.8:0, duration: const Duration(milliseconds: 400),
                  child: Container(
                    width: sizeP.width*0.5,
                    height: height,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: colorWhite
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonIconCPNT.icon(onPressed: !obj.tools?(){}:(){
                          _editObject(context, obj);
                        }, size: Size(sizeP.width*0.5*0.15,sizeP.width*0.5*0.15), icon: Icons.edit, color: color2),
                        ButtonIconCPNT.icon(onPressed: !obj.tools?(){}: ()async{
                          var result=await showDialog(context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly
                                    ,children: [
                                    TextSubtitleCPNT(colorText: color2, text: "Confirmar eliminación", weight: FontWeight.w700),
                                    Icon(
                                      Icons.announcement,
                                      color: errorcolor,
                                      size: 25,
                                    ),
                                  ],
                                  ),
                                  content: TextParagraphCPNT(onPressed: (){}, colorText: color2, text: "¿Desea eliminar esta colección?"),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FlatButton(
                                          onPressed: () => Navigator.pop(context,false),
                                          child: Text("Cancelar",
                                            style: TextStyle(
                                              color: colorWhite,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          color: color2,
                                        ),
                                        FlatButton(
                                          onPressed: (){Navigator.pop(context,true);},
                                          child: Text("Eliminar",
                                            style: TextStyle(
                                              color: colorWhite,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          color: errorcolor,
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              });
                          if(result==true){

                            context.read<MyObjectsBloc>().add(MyObjectsDelete(obj.idObject));
                          }
                        }, size: Size(sizeP.width*0.5*0.15,sizeP.width*0.5*0.15), icon: Icons.delete, color: color2),
                        ButtonIconCPNT.icon(onPressed: !obj.tools?(){}:(){
                          context.read<MyObjectsBloc>().add(MyObjectsChangeTools(i));
                        }, size: Size(sizeP.width*0.5*0.15,sizeP.width*0.5*0.15), icon: Icons.keyboard_backspace, color: color2),
                      ],
                    ),
                  ))
          ]
        )
      )
      );
    }
    return list;
  }

  List<StaggeredTile> getListTile(List collectionList){
    List<StaggeredTile> list=[];
    for(var i=0;i<collectionList.length;i++){
      if(i%3==0){
        list.add(const StaggeredTile.fit(1));

      }
      else{

        list.add(const StaggeredTile.fit(1));
      }
    }
    return list;
  }
  void addObject(BuildContext context){
    print("asdf");
    context.read<MyObjectsBloc>().add(MyObjectsInitForm());
    print("asdf");
    Navigator.push(context, MaterialPageRoute(builder: (_)=>
        BlocProvider.value(
          value: BlocProvider.of<MyObjectsBloc>(context),
          child: ObjectForm(false),
        )));

    print("asdf3");
  }
  void _editObject(BuildContext context,ObjectSimple obj){
    print("asdf");
    context.read<MyObjectsBloc>().add(MyObjectsGetObject(obj.idObject));
    print("asdf");
    Navigator.push(context, MaterialPageRoute(builder: (_)=>
        BlocProvider.value(
          value: BlocProvider.of<MyObjectsBloc>(context),
          child: ObjectForm(true),
        )));

    print("asdf3");
  }

  
}