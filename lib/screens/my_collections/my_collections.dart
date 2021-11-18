import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:recollar/bloc/my_collections_bloc.dart';
import 'package:recollar/events/my_collections_event.dart';
import 'package:recollar/general_widgets/button_icon_cpnt.dart';
import 'package:recollar/general_widgets/loading_cpnt.dart';
import 'package:recollar/general_widgets/simple_card_cpnt.dart';
import 'package:recollar/general_widgets/text_paragraph_cpnt.dart';
import 'package:recollar/general_widgets/text_subtitle_cpnt.dart';
import 'package:recollar/general_widgets/text_title_cpnt.dart';
import 'package:recollar/models/collection.dart';
import 'package:recollar/repositories/my_collections_repository.dart';
import 'package:recollar/screens/my_collections/collection_form.dart';
import 'package:recollar/screens/my_objects/my_objects.dart';
import 'package:recollar/state/my_collections_state.dart';
import 'package:recollar/util/configuration.dart';
import 'package:image_picker/image_picker.dart';
class MyCollections extends StatefulWidget {
  const MyCollections({Key? key}) : super(key: key);

  @override
  _MyCollectionsState createState() => _MyCollectionsState();
}

class _MyCollectionsState extends State<MyCollections>  with AutomaticKeepAliveClientMixin{
  Size sizeP=const Size(1,1);
  final ScrollController _scrollController=ScrollController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    sizeP=MediaQuery.of(context).size;
    return BlocProvider(
      create: (context)=>MyCollectionsBloc(MyCollectionsRepository())..add(MyCollectionsInit()),
      child: BlocBuilder<MyCollectionsBloc,MyCollectionsState>(
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

                          children: getList(state.collections,context),
                          staggeredTiles: getListTile(state.collections),
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
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top,left: sizeP.width*0.05,right: sizeP.width*0.05),
                  width: sizeP.width,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ButtonIconCPNT.icon(onPressed: (){}, size: const Size(30,20),icon: Icons.fact_check,color: colorWhite),
                                  TextTitleCPNT(onPressed: (){}, colorText: colorWhite, text: "Mi Colección",weight: FontWeight.w600,),
                            ],
                          ),
                          ButtonIconCPNT.icon(onPressed: (){
                            addCollection(context);
                          }, size: const Size(40,20),icon: Icons.add_circle_outlined,color: color1)
                        ],
                      )
                    ],
                  ),
                ),
                state is MyCollectionsLoading?LoadingCPNT(size: sizeP):Container()
              ],
            )
          );
        }
      ),
    );
  }

  List<Widget> getList(List<Collection> collectionList,BuildContext context){
    List<Widget> list=[];
    var height=200.0;
    for(var i=0;i<collectionList.length;i++){
      var col=collectionList[i];
      print(col.image);
      list.add(GestureDetector(
        onLongPress: (){
          context.read<MyCollectionsBloc>().add(MyCollectionsChangeTools(i));
        },
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> MyObjects(col)));
          },
        child:
            Stack(
              children: [
                SimpleCardCPNT(color: color2,
                  colorBg: colorWhite,
                  text: col.name,
                  text2: "Artículos: ${col.amount}",
                  firstColor: maskcolor1,
                  secondColor: maskcolor2,
                  textColor: color2,
                  size: Size(sizeP.width*0.5, height),
                  image: col.image,
                  token:col.token,
                  imagePath: "imageCollection",
                  box: BoxFit.cover,
                  onPressed: (){
                  },
                ),
                AnimatedOpacity(opacity: col.tools?0.8:0, duration: const Duration(milliseconds: 400),
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
                          ButtonIconCPNT.icon(onPressed: !col.tools?null:(){

                            editCollection(context,col);
                          }, size: Size(sizeP.width*0.5*0.15,sizeP.width*0.5*0.15), icon: Icons.edit, color: color2),
                          ButtonIconCPNT.icon(onPressed: !col.tools?null: ()async{
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
                                    content: TextParagraphCPNT( colorText: color2, text: "¿Desea eliminar esta colección?"),
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
                                            onPressed: (){
                                              Navigator.pop(context,true);

                                            },
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

                              context.read<MyCollectionsBloc>().add(MyCollectionsDelete(col.idCollection));
                            }
                          }, size: Size(sizeP.width*0.5*0.15,sizeP.width*0.5*0.15), icon: Icons.delete, color: color2),
                          ButtonIconCPNT.icon(onPressed: !col.tools?null:(){
                            context.read<MyCollectionsBloc>().add(MyCollectionsChangeTools(i));
                          }, size: Size(sizeP.width*0.5*0.15,sizeP.width*0.5*0.15), icon: Icons.arrow_back, color: color2),
                        ],
                      ),
                    ))
              ],
            )
      ));
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
  void addCollection(BuildContext context){
    context.read<MyCollectionsBloc>().add(MyCollectionsInitForm(null));
    Navigator.push(context, MaterialPageRoute(builder: (_)=>
    BlocProvider.value(
      value: BlocProvider.of<MyCollectionsBloc>(context),
      child: const CollectionForm(edit:false),
    )));
  }
  void editCollection(BuildContext context,Collection collection){
    context.read<MyCollectionsBloc>().add(MyCollectionsInitForm(collection));
    Navigator.push(context, MaterialPageRoute(builder: (_)=>
        BlocProvider.value(
          value: BlocProvider.of<MyCollectionsBloc>(context),
          child: const CollectionForm(edit: true),
        )));
  }

  @override
  bool get wantKeepAlive => true;


}
