import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recollar/bloc/my_objects_bloc.dart';
import 'package:recollar/events/my_objects_event.dart';
import 'package:recollar/general_widgets/button_primary_cpnt.dart';
import 'package:recollar/general_widgets/loading_cpnt.dart';
import 'package:recollar/general_widgets/text_field_primary_cpnt.dart';
import 'package:recollar/general_widgets/text_subtitle_cpnt.dart';
import 'package:recollar/general_widgets/text_title_cpnt.dart';
import 'package:recollar/models/object_request.dart';
import 'package:recollar/screens/my_objects/widgets/preview_ar.dart';
import 'package:recollar/state/my_objects_state.dart';
import 'package:recollar/util/configuration.dart';
import 'package:recollar/models/object.dart';
import 'package:recollar/screens/my_collections/widgets/no_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
class ObjectForm extends StatefulWidget{
  final bool edit;
  ObjectForm(this.edit){
    print("algo");
  }
  @override
  _ObjectFormState createState() => _ObjectFormState();
}

class _ObjectFormState extends State<ObjectForm>{
  TextEditingController nameController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  TextEditingController priceController=TextEditingController();
  Uint8List ? _imageAR;
  int  _objectStatus=5;
  bool _ar=false;

  XFile ?_imagePublication;
  Size sizeP=const Size(1,1);
  bool firstBuild=true;

  @override
  Widget build(BuildContext context) {
    sizeP=MediaQuery.of(context).size;
    return BlocBuilder<MyObjectsBloc,MyObjectsState>(
        builder: (context,state) {
          if(state is MyObjectsGetObjectOk){
            if(state.object!=null && firstBuild){
              nameController.text=state.object!.name;
              descriptionController.text=state.object!.description;
              priceController.text=state.object!.price.toString();
              _ar=state.object!.ar;
              _objectStatus=state.object!.objectStatus;
              firstBuild=false;
            }
          }

          if(state is MyObjectsAddOk){
            WidgetsBinding.instance!.addPostFrameCallback((_){
              Navigator.pop(context);
            });
          }
          return WillPopScope(
            onWillPop: ()async{
              context.read<MyObjectsBloc>().add(MyObjectsInit());
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: color1, //change your color here
                ),
                leadingWidth: 30,
                title: TextTitleCPNT( colorText: colorWhite, text: widget.edit?"Editar objeto":"Nuevo objeto", weight: FontWeight.w600),
                backgroundColor: color2,
                actions: [
                  ButtonPrimaryCPNT(onPressed: (){
                    if(widget.edit){
                      _edit(context,state.object!);

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
                      padding: const EdgeInsets.only(top:20),
                      children: [
                        Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            ButtonPrimaryCPNT(
                                onPressed: (){
                                    _openCamera(context);
                                },
                                size: Size(sizeP.width*0.5,sizeP.width*0.1),
                                colorBg: _ar!=null?color1:color1.withOpacity(0.3),
                                colorText: _ar!=null?color2:color2.withOpacity(0.5),
                                text: _ar?"AR Habilitado":"Habilitar AR",

                                elevation: 0)
                          ],
                        ),
                const SizedBox(height: 30,)
                        ,
                        Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                if( _imageAR==null){

                                  _openGallery();
                                }
                              },
                              child: ClipRRect(

                                child:_imageAR!=null?Image.memory(_imageAR!,fit:_ar?BoxFit.contain:BoxFit.cover,width: sizeP.width*0.7,height:  sizeP.width*0.7):
                                _imagePublication!=null?Image(image:FileImage(File(_imagePublication!.path)),fit:_ar?BoxFit.contain:BoxFit.cover,width: sizeP.width*0.7,height:  sizeP.width*0.7,):
                                widget.edit&&state.object!=null?Image.network("http://"+(dotenv.env['API_URL'] ?? "")+"${dotenv.env['API_URL_COMP'] ?? ""}/image/"+state.object!.image,headers: {"Authorization":"Bearer ${state.object!.token}"},fit:_ar?BoxFit.contain:BoxFit.cover,width: sizeP.width*0.7,height:  sizeP.width*0.7,):NoImage(size:Size(sizeP.width*0.7,sizeP.width*0.7)),
                                borderRadius:  BorderRadius.circular(10),

                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30,),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: sizeP.width*0.05),
                            child:
                            TextSubtitleCPNT( colorText: color2.withOpacity(0.7), text: "Nombre del objeto", weight: FontWeight.w600)

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
                            TextSubtitleCPNT( colorText: color2.withOpacity(0.7), text: "Descripción", weight: FontWeight.w600)

                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            TextFieldPrimaryCPNT(maxLength: 50,onChanged: (text){},icon: null, textType: TextInputType.text, obscureText: false, controller: descriptionController, colorBorder: colorWhite, size: Size(sizeP.width*0.9,50), colorBg: colorWhite, colorText: color2, hintText: ""),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: sizeP.width*0.05),
                            child:
                            TextSubtitleCPNT( colorText: color2.withOpacity(0.7), text: "Precio", weight: FontWeight.w600)

                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            TextFieldPrimaryCPNT(maxLength: 50,onChanged: (text){},icon: null, textType: TextInputType.number, obscureText: false, controller: priceController, colorBorder: colorWhite, size: Size(sizeP.width*0.9,50), colorBg: colorWhite, colorText: color2, hintText: ""),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: sizeP.width*0.05),
                            child:
                            TextSubtitleCPNT( colorText: color2.withOpacity(0.7), text: "Estado del Objeto", weight: FontWeight.w600)

                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width:sizeP.width*0.7,
                              height: 20,
                              child: SfSlider(
                                min: 1,
                                max: 10,
                                activeColor: color1,
                                inactiveColor: color2.withOpacity(0.5),
                                value: _objectStatus,
                                thumbIcon: Center(child: Text(_objectStatus.toString()),),
                                interval: 1,
                                enableTooltip: true,

                                onChanged: (dynamic value){
                                  setState(() {
                                    var value2=value as double;
                                    _objectStatus = value2.toInt();
                                  });
                                },
                              ),
                            )
                            ],
                        ),

                        const SizedBox(height: 100,),
                      ],
                    ),
                  ),
                  state is MyObjectsFormLoading?LoadingCPNT(size: sizeP):Container()
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
  _openCamera(BuildContext context) async {
    var imagePicker = ImagePicker();
    var picture = await imagePicker.pickImage(source: ImageSource.camera);
    if (picture != null) {
      context.read<MyObjectsBloc>().add(MyObjectsRemoveBgInit(picture));
      var image=await Navigator.push(context, MaterialPageRoute(builder: (_)=>
          BlocProvider.value(
            value: BlocProvider.of<MyObjectsBloc>(context),
            child: PreviewAR(),
          )));
        if(image!=null){
          setState(() {
            _imageAR=image;
            _ar=true;
          });
        }
    }
  }

  _add(BuildContext context){

    ObjectRequest objectRequest = ObjectRequest(null,null,nameController.text,descriptionController.text,_objectStatus,double.parse(priceController.text),_ar);

    if(_imageAR!=null){
      context.read<MyObjectsBloc>().add(MyObjectsAdd(objectRequest,null,_imageAR));
    }
    else{
      context.read<MyObjectsBloc>().add(MyObjectsAdd(objectRequest,_imagePublication,null));

    }
  }
  _edit(BuildContext context,Object object){
    ObjectRequest objectRequest = ObjectRequest(object.idObject,object.idCollection,nameController.text,descriptionController.text,_objectStatus,double.parse(priceController.text),_ar);

    if(_imageAR!=null){
      context.read<MyObjectsBloc>().add(MyObjectsUpdate(objectRequest,null,_imageAR));
    }
    else{
      context.read<MyObjectsBloc>().add(MyObjectsUpdate(objectRequest,_imagePublication,null));

    }
  }
}