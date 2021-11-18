import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recollar/bloc/login_bloc.dart';
import 'package:recollar/events/login_event.dart';
import 'package:recollar/general_widgets/button_primary_cpnt.dart';
import 'package:recollar/general_widgets/loading_cpnt.dart';
import 'package:recollar/general_widgets/text_field_primary_cpnt.dart';
import 'package:recollar/general_widgets/text_paragraph_cpnt.dart';
import 'package:recollar/models/user.dart';
import 'package:recollar/state/login_state.dart';
import 'package:recollar/util/configuration.dart';
import 'package:recollar/util/my_behavior.dart';
import 'package:recollar/screens/login/widgets/carousel.dart';
import 'package:recollar/screens/login/widgets/social_media.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  List<ImageProvider> backgroundImages=[];
  List<ImageProvider> socialMediaImages=[];
  TextEditingController firstNameTextController= TextEditingController();
  TextEditingController lastNameTextController= TextEditingController();
  TextEditingController phoneNumberTextController= TextEditingController();
  TextEditingController emailTextController= TextEditingController();
  TextEditingController passTextController= TextEditingController();
  TextEditingController verifyPassTextController= TextEditingController();
  ScrollController listController=ScrollController();
  Size sizeP=const Size(1,1);
  bool socialMediaActive=false;
  @override
  void initState() {
    backgroundImages.add(const AssetImage("assets/background/b1.jpg"));
    backgroundImages.add(const AssetImage("assets/background/b2.jpg"));
    backgroundImages.add(const AssetImage("assets/background/b3.jpg"));
    socialMediaImages.add(const AssetImage("assets/icons/fb.png"));
    socialMediaImages.add(const AssetImage("assets/icons/git.png"));
    socialMediaImages.add(const AssetImage("assets/icons/tt.png"));
    listController=ScrollController();
    listController.addListener(() {
      setState(() {
        if(sizeP.height>825)socialMediaActive=true;
      });
      if(listController.position.pixels==listController.position.maxScrollExtent){
        setState(() {
          socialMediaActive=true;
        });
      }
      else{
        setState(() {
          socialMediaActive=false;
        });
      }
    });
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(backgroundImages[0], context);
    precacheImage(backgroundImages[1], context);
    precacheImage(backgroundImages[2], context);
    precacheImage(socialMediaImages[0], context);
    precacheImage(socialMediaImages[1], context);
    precacheImage(socialMediaImages[2], context);
  }
  @override
  Widget build(BuildContext context) {
    sizeP=MediaQuery.of(context).size;
    return BlocBuilder<LoginBloc,LoginState>(
        builder: (context,state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
                children: [
                  Carousel(size: sizeP, images: backgroundImages),
                  Container(color: Colors.black.withOpacity(0.7), height: sizeP.height, width: sizeP.width),
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    body: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                        controller: listController,
                        child: Container(
                          height: sizeP.height>825?sizeP.height:825,
                          width: sizeP.width,
                          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/logo.png",width: sizeP.width*0.6,height: 70,),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  TextFieldPrimaryCPNT(onPressed:(){},icon:Icons.person_add,textType: TextInputType.text,obscureText: false, controller: firstNameTextController, colorBorder: colorWhite, size: Size(sizeP.width*0.7,50), colorBg: Colors.transparent, colorText: colorWhite, hintText: "Nombres"),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  TextFieldPrimaryCPNT(onPressed:(){},icon:Icons.person_add,textType: TextInputType.text,obscureText: false, controller: lastNameTextController, colorBorder: colorWhite, size: Size(sizeP.width*0.7,50), colorBg: Colors.transparent, colorText: colorWhite, hintText: "Apellidos"),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  TextFieldPrimaryCPNT(onPressed:(){},icon:Icons.phone,textType: TextInputType.phone,obscureText: false, controller: phoneNumberTextController, colorBorder: colorWhite, size: Size(sizeP.width*0.7,50), colorBg: Colors.transparent, colorText: colorWhite, hintText: "Numero de celular"),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  TextFieldPrimaryCPNT(onPressed:(){},icon:Icons.person,textType: TextInputType.emailAddress,obscureText: false, controller: emailTextController, colorBorder: colorWhite, size: Size(sizeP.width*0.7,50), colorBg: Colors.transparent, colorText: colorWhite, hintText: "Correo Electrónico"),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  TextFieldPrimaryCPNT(onPressed:(){},icon:Icons.lock,textType: TextInputType.text,obscureText: true, controller: passTextController, colorBorder: colorWhite, size: Size(sizeP.width*0.7,50), colorBg: Colors.transparent, colorText: colorWhite, hintText: "Contraseña"),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  TextFieldPrimaryCPNT(onPressed:(){},icon:Icons.lock,textType: TextInputType.text,obscureText: true, controller: verifyPassTextController, colorBorder: colorWhite, size: Size(sizeP.width*0.7,50), colorBg: Colors.transparent, colorText: colorWhite, hintText: "Verificar contraseña"),

                                  const SizedBox(
                                    height: 25,
                                  ),
                                  ButtonPrimaryCPNT( elevation: 5,colorBg: colorWhite.withOpacity(0.7), colorText: colorBlack, text: "REGISTRARSE",size: Size(sizeP.width*0.7,50),
                                    onPressed:  (){
                                      FocusScope.of(context).unfocus();
                                      User user= User(emailTextController.text, firstNameTextController.text, lastNameTextController.text, int.parse(phoneNumberTextController.text), passTextController.text);
                                      user.verPassword=verifyPassTextController.text;
                                      context.read<LoginBloc>().add(SignupClick(user));
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextParagraphCPNT(onPressed: (){}, colorText: colorWhite.withOpacity(0.7), text: "¿Ya tienes una cuenta?"),
                                  TextParagraphCPNT(onPressed: (){context.read<LoginBloc>().add(LoginChangePage());}, colorText: colorWhite, text: "Iniciar Sesión"),

                                ],

                              ),
                            ],
                          ),
                        ),
                      )
                    ),
                  ),
                  socialMediaActive|| sizeP.height>825?Positioned(
                    child:SocialMedia(size: Size(sizeP.width*0.3,sizeP.width*0.1),images: socialMediaImages,)
                    ,top:sizeP.height-sizeP.width*0.2,width: sizeP.width,):Container(),
                  state is SignupLoading?LoadingCPNT(size: sizeP):Container()
                ],
              ),
          );
        }
    );
  }


}
