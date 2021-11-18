import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recollar/bloc/login_bloc.dart';
import 'package:recollar/events/login_event.dart';
import 'package:recollar/general_widgets/button_primary_cpnt.dart';
import 'package:recollar/general_widgets/loading_cpnt.dart';
import 'package:recollar/general_widgets/text_field_primary_cpnt.dart';
import 'package:recollar/general_widgets/text_paragraph_cpnt.dart';
import 'package:recollar/state/login_state.dart';
import 'package:recollar/util/configuration.dart';
import 'package:recollar/models/user_auth.dart';
import 'package:recollar/util/my_behavior.dart';
import 'package:recollar/screens/login/widgets/carousel.dart';
import 'package:recollar/screens/login/widgets/social_media.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<ImageProvider> backgroundImages=[];
  List<ImageProvider> socialMediaImages=[];
  TextEditingController userTextController= TextEditingController();
  TextEditingController passTextController= TextEditingController();
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
        if(sizeP.height>600)socialMediaActive=true;
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
          backgroundColor: Colors.red,

          body: Stack(
            children: [
              Carousel(size: sizeP, images: backgroundImages),
              Container(color: Colors.black.withOpacity(0.7), height: sizeP.height, width: sizeP.width),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child:SingleChildScrollView(
                    controller: listController,
                    child: SizedBox(
                      height: sizeP.height>600?sizeP.height:600,
                      width: sizeP.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/square_logo.png",width: sizeP.width*0.6,height: 140,),
                              const SizedBox(
                                height: 50,
                              ),
                              TextFieldPrimaryCPNT(icon:Icons.person,textType: TextInputType.emailAddress,obscureText: false, controller: userTextController, colorBorder: colorWhite, size: Size(sizeP.width*0.7,50), colorBg: Colors.transparent, colorText: colorWhite, hintText: "Correo Electrónico"),
                              const SizedBox(
                                height: 25,
                              ),
                              TextFieldPrimaryCPNT(icon:Icons.lock,textType: TextInputType.text,obscureText: true, controller: passTextController, colorBorder: colorWhite, size: Size(sizeP.width*0.7,50), colorBg: Colors.transparent, colorText: colorWhite, hintText: "Contraseña"),
                              const SizedBox(
                                height: 25,
                              ),
                              ButtonPrimaryCPNT( elevation: 5,colorBg: color1, colorText: Colors.black, text: "INICIAR SESIÓN",size: Size(sizeP.width*0.7,50),
                                onPressed:  (){
                                  FocusScope.of(context).unfocus();
                                  UserAuth userAuth=UserAuth(passTextController.text, userTextController.text);
                                  context.read<LoginBloc>().add(LoginClick(userAuth));
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextParagraphCPNT(onPressed: (){}, colorText: colorWhite.withOpacity(0.7), text: "¿No tienes una cuenta?"),
                              TextParagraphCPNT(onPressed: (){context.read<LoginBloc>().add(SignupChangePage());}, colorText: colorWhite, text: "Crear una cuenta"),

                            ],

                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              socialMediaActive|| sizeP.height>600?Positioned(
                child:SocialMedia(size: Size(sizeP.width*0.3,sizeP.width*0.1),images: socialMediaImages,)
                ,top:sizeP.height-sizeP.width*0.2,width: sizeP.width,):Container(),
              state is LoginLoading?LoadingCPNT(size: sizeP):Container()
            ],
          ),
        );
      }
    );
  }


}
