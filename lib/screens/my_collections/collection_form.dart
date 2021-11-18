import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recollar/bloc/my_collections_bloc.dart';
import 'package:recollar/events/my_collections_event.dart';
import 'package:recollar/general_widgets/button_primary_cpnt.dart';
import 'package:recollar/general_widgets/combo_box_primary_cpnt.dart';
import 'package:recollar/general_widgets/loading_cpnt.dart';
import 'package:recollar/general_widgets/text_field_primary_cpnt.dart';
import 'package:recollar/general_widgets/text_subtitle_cpnt.dart';
import 'package:recollar/general_widgets/text_title_cpnt.dart';
import 'package:recollar/models/category.dart';
import 'package:recollar/models/collection.dart';
import 'package:recollar/models/collection_request.dart';
import 'package:recollar/models/combo_box_item.dart';
import 'package:recollar/screens/my_collections/widgets/no_image.dart';
import 'package:recollar/state/my_collections_state.dart';
import 'package:recollar/util/configuration.dart';

class CollectionForm extends StatefulWidget {
  final bool edit;
  const CollectionForm({Key? key,required this.edit}) : super(key: key);

  @override
  _CollectionFormState createState() => _CollectionFormState();
}

class _CollectionFormState extends State<CollectionForm> {
  TextEditingController nameController=TextEditingController();
  ComboBoxItem comboBoxItem=ComboBoxItem(null, null);
  List<ComboBoxItem> items=[];
  XFile ?_imagePublication;
  Size sizeP=const Size(1,1);
  bool firstBuild=false;
  @override
  Widget build(BuildContext context) {
    sizeP=MediaQuery.of(context).size;
    return BlocBuilder<MyCollectionsBloc,MyCollectionsState>(
      builder: (context,state) {
        if(state is MyCollectionsForm && !firstBuild){
          _chargeCategoriesComboBox(state.category);
          if(widget.edit){
              nameController.text=state.collection!.name;
              comboBoxItem=ComboBoxItem(state.collection!.idCategory, state.category.firstWhere((element) => element.idCategory==state.collection!.idCategory).name);
             }
          firstBuild=true;
        }
        
        return WillPopScope(
          onWillPop: ()async{
            context.read<MyCollectionsBloc>().add(MyCollectionsInit());
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: color1, //change your color here
              ),
              leadingWidth: 30,
              title: TextTitleCPNT( colorText: colorWhite, text: widget.edit?"Editar colección":"Nueva collección", weight: FontWeight.w600),
              backgroundColor: color2,
              actions: [
                ButtonPrimaryCPNT(onPressed: (){
                  if(widget.edit){
                    _edit(context,state.collection!);

                  }else{
                    _add(context);
                  }
                }, size: Size(sizeP.width*0.1,10), colorBg: color2, colorText: color1, text: "aceptar", elevation: 0)
              ],
              elevation: 1,
            ),
            body: Stack(
              children: [
                Scaffold(
                  backgroundColor: colorGray,

                  body: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top:70),
                    children: [
                            Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    _openGallery();
                                  },
                                  child: ClipRRect(

                                    child:
                                    _imagePublication!=null?Image(image:FileImage(File(_imagePublication!.path)),fit:BoxFit.cover,width: sizeP.width*0.7,height:  sizeP.width*0.7,):
                                        widget.edit&&state.collection!=null?Image.network("http://"+(dotenv.env['API_URL'] ?? "")+"${dotenv.env['API_URL_COMP'] ?? ""}/image/"+state.collection!.image,headers: {"Authorization":"Bearer ${state.collection!.token}"},fit:BoxFit.cover,width: sizeP.width*0.7,height:  sizeP.width*0.7,):NoImage(size:Size(sizeP.width*0.7,sizeP.width*0.7)),
                                    borderRadius:  BorderRadius.circular(10),

                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 30,),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: sizeP.width*0.05),
                                child:
                                TextSubtitleCPNT( colorText: color2.withOpacity(0.7), text: "Nombre de la colección", weight: FontWeight.w600)

                            ),
                      const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: [
                                TextFieldPrimaryCPNT(maxLength: 50,onChanged: (text){},icon: null, textType: TextInputType.text, obscureText: false, controller: nameController, colorBorder: colorWhite, size: Size(sizeP.width*0.9,50), colorBg: colorWhite, colorText: color2, hintText: ""),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: sizeP.width*0.05),
                                child:
                                TextSubtitleCPNT( colorText: color2.withOpacity(0.7), text: "Categoria", weight: FontWeight.w600)

                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: [
                                ComboBoxPrimaryCPNT(items: items,comboBoxItem: comboBoxItem, colorBorder: colorWhite, size: Size(sizeP.width*0.9,50), colorBg: colorWhite, colorText: color2, hintText: "categoria")
                                 ],
                            ),

                            const SizedBox(height: 100,),
                          ],
                  ),
                ),
                state is MyCollectionsLoadingForm?LoadingCPNT(size: sizeP):Container()
              ],
            ),
          ),
        );
      }
    );
  }
  _openGallery() async {
    var imagePicker = ImagePicker();
    var picture = await imagePicker.pickImage(source: ImageSource.gallery);
    if (picture != null) {
      setState(() {
        _imagePublication=picture;
      });
    }
    //this.setState({});
  }
  void _chargeCategoriesComboBox(List<Category> categories){
    List<ComboBoxItem> list=[];
    for(var cat in categories){
      list.add(ComboBoxItem(cat.idCategory, cat.name));
    }
    items=list;
  }
  _add(BuildContext context){
    CollectionRequest collectionRequest= CollectionRequest(1, nameController.text, comboBoxItem.id??1);

    context.read<MyCollectionsBloc>().add(MyCollectionsAdd(collectionRequest,_imagePublication??XFile("")));
    Navigator.pop(context);
  }
  _edit(BuildContext context,Collection collection){
    CollectionRequest collectionRequest= CollectionRequest(collection.idCollection, nameController.text, comboBoxItem.id??1);

    context.read<MyCollectionsBloc>().add(MyCollectionsUpdate(collectionRequest,_imagePublication));
    Navigator.pop(context);
  }
}
