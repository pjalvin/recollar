import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recollar/bloc/login_bloc.dart';
import 'package:recollar/bloc/profile_bloc.dart';
import 'package:recollar/events/login_event.dart';
import 'package:recollar/events/profile_event.dart';
import 'package:recollar/general_widgets/button_icon_cpnt.dart';
import 'package:recollar/general_widgets/button_primary_cpnt.dart';
import 'package:recollar/general_widgets/loading_cpnt.dart';
import 'package:recollar/general_widgets/text_field_primary_cpnt.dart';
import 'package:recollar/general_widgets/text_paragraph_cpnt.dart';
import 'package:recollar/general_widgets/text_subtitle_cpnt.dart';
import 'package:recollar/general_widgets/text_title_cpnt.dart';
import 'package:recollar/models/password_request.dart';
import 'package:recollar/models/profile_request.dart';
import 'package:recollar/models/user.dart';
import 'package:recollar/repositories/profile_repository.dart';
import 'package:recollar/screens/profile/widgets/change_pass_alert.dart';
import 'package:recollar/state/profile_state.dart';
import 'package:recollar/util/configuration.dart';
import 'package:recollar/util/toast_lib.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>  with AutomaticKeepAliveClientMixin{
  TextEditingController firstNameController=TextEditingController();
  TextEditingController lastNameController=TextEditingController();
  TextEditingController phoneNumberController=TextEditingController();
  bool _editActive=false;
  Size sizeP=const Size(1,1);
  bool firstBuild=false;
  @override
  Widget build(BuildContext context) {
    sizeP=MediaQuery.of(context).size;
    super.build(context);
    return  BlocProvider(
        create: (context)=>ProfileBloc(ProfileRepository())..add(ProfileInit()),
      child: BlocBuilder<ProfileBloc,ProfileState>(
        builder: (context,state){
          if(state is ProfileOk && !firstBuild){
            firstNameController.text=state.user.firstName;
            lastNameController.text=state.user.lastName;
            phoneNumberController.text=state.user.phoneNumber.toString();
            firstBuild=true;
          }
          return Stack(
            children: [
              Scaffold(
                backgroundColor: colorGray,

                body: ListView(
                  padding: const EdgeInsets.only(top:70),
                  children: [
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Container(
                          width: sizeP.width*0.3,
                          height: sizeP.width*0.3,
                          child: ButtonIconCPNT.icon(onPressed: (){
                            context.read<ProfileBloc>().add(LockChange());
                          }, size: Size(sizeP.width*0.2,sizeP.width*0.2), icon: Icons.lock, color: state.lock?color1:colorGray),
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius:  BorderRadius.circular(sizeP.width*0.25),
                          ),

                        )
                      ],
                    ),
                    const SizedBox(height: 10,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: sizeP.width*0.1,
                            child:TextSubtitleCPNT(colorText: state.lock?color2:color2.withOpacity(0.3), text: !state.lock?"Seguridad desactivada":"Seguridad Activada", weight: FontWeight.w600,)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: sizeP.width*0.1),
                      child: Divider(
                        color: color2.withOpacity(0.5),
                        height: 3,
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: sizeP.width,
                            child: TextTitleCPNT(maxLines: 1,onPressed: (){}, colorText: color2, text: state.user.firstName+" "+state.user.lastName, weight: FontWeight.w700))
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        TextParagraphCPNT(onPressed: (){}, colorText: colorBlack.withOpacity(0.3), text: state.user.email)
                      ],
                    ),
                    const SizedBox(height: 40,),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: sizeP.width*0.15),
                        child:
                        TextSubtitleCPNT(onPressed: (){}, colorText: color2.withOpacity(0.7), text: "Nombre(s)", weight: FontWeight.w200)

                    ),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        TextFieldPrimaryCPNT(maxLength: 50,onChanged: (text){verifyData(state.user);},icon: null, textType: TextInputType.text, obscureText: false, controller: firstNameController, colorBorder: colorWhite, size: Size(sizeP.width*0.7,50), colorBg: colorWhite, colorText: color2, hintText: state.user.firstName),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: sizeP.width*0.15),
                        child:
                        TextSubtitleCPNT(onPressed: (){}, colorText: color2.withOpacity(0.7), text: "Apellido(s)", weight: FontWeight.w200)

                    ),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        TextFieldPrimaryCPNT(maxLength: 50,onChanged: (text){verifyData(state.user);},icon: null, textType: TextInputType.text, obscureText: false, controller: lastNameController, colorBorder: colorWhite, size: Size(sizeP.width*0.7,50), colorBg: colorWhite, colorText: color2, hintText: state.user.lastName),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: sizeP.width*0.15),
                      child:
                        TextSubtitleCPNT(onPressed: (){}, colorText: color2.withOpacity(0.7), text: "Numero de celular", weight: FontWeight.w200)

                    ),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        TextFieldPrimaryCPNT(maxLength:8,onChanged: (text){verifyData(state.user);},icon: null, textType: TextInputType.number, obscureText: false, controller: phoneNumberController, colorBorder: colorWhite, size: Size(sizeP.width*0.7,50), colorBg: colorWhite, colorText: color2, hintText: state.user.phoneNumber.toString()),
                      ],
                    ),

                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        ButtonPrimaryCPNT( elevation: 0,colorBg: _editActive?color1:colorBlack.withOpacity(0.1), colorText:  _editActive?color2:color2.withOpacity(0.3), text: "Actualizar",size: Size(sizeP.width*0.5,50),
                          onPressed:  !_editActive?null:(){
                            changeData(context);
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color:color2))
                            ),
                            child:
                            TextParagraphCPNT(onPressed: ()async{
                              PasswordRequest? newPassword=await showDialog(context: context,
                                  builder: (context){
                                  return ChangePassAlert();
                              });


                              FocusScope.of(context).unfocus();
                              if(newPassword!=null){
                                context.read<ProfileBloc>().add(PasswordChange(newPassword));
                              }
                            }, colorText: color2, text: "Cambiar contraseña",)

                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: sizeP.width*0.1),
                      child: Divider(
                        color: color2.withOpacity(0.5),
                          height: 40,
                      ),
                    ),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        TextSubtitleCPNT(onPressed: (){},  colorText: color2, text: "Política de privacidad",weight: FontWeight.w200,),
                        Icon(Icons.arrow_right,color: color2,)
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        ButtonPrimaryCPNT( elevation: 0,colorBg: color2, colorText: colorWhite, text: "Cerrar Sesión",size: Size(sizeP.width*0.5,50),
                          onPressed:  (){
                          signOut();
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 100,),
                  ],
                ),
              ),
              state is ProfileLoading?LoadingCPNT(size: sizeP):Container()
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void verifyData(User user){
    if(user.firstName!=firstNameController.text||user.lastName!=lastNameController.text||user.phoneNumber!=int.parse(phoneNumberController.text)){
      setState(() {
        _editActive=true;
      });
    }
    else{
      setState(() {
        _editActive=false;
      });
    }
  }
  void changeData(BuildContext context){
    try{
      FocusScope.of(context).unfocus();

      ProfileRequest p=ProfileRequest(firstNameController.text,lastNameController.text,int.parse(phoneNumberController.text));
      context.read<ProfileBloc>().add(ProfileChange(p));

      setState(() {
        _editActive=false;
      });
    }
    on FormatException catch(_){
      ToastLib.error("Error en el formato de los inputs");

    }
    catch(e){
      ToastLib.error(e.toString());
    }
  }
  void signOut(){
    context.read<LoginBloc>().add(SignOut());
  }

}
