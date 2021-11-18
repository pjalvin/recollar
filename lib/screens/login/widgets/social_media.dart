
import 'package:flutter/material.dart';
import 'package:recollar/general_widgets/button_icon_cpnt.dart';

import 'package:url_launcher/url_launcher.dart';

class SocialMedia extends StatelessWidget {
  SocialMedia({Key? key, required this.size,required this.images}) : super(key: key);
  Size size;
  List<ImageProvider> images;

  final String _launchGithub = 'https://github.com/pjalvin/recollar';
  final String _launchFacebook = 'https://www.facebook.com/Cabalito-104841941479769/?view_public_for=104841941479769';
  final String _launchTwitter = 'https://twitter.com/Cabalito4';
  Future<void> _launchInBrowser(String url)async{
    if(await canLaunch(url)){
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
        headers: <String,String>{'header_key': 'header_value'},
      );
    }else{
      throw 'No se puede abrir $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonIconCPNT.image(image: images[0],
          size: Size(size.width * 0.3, size.height),
          onPressed: () {
            _launchInBrowser(_launchFacebook);
          },),
        SizedBox(
          width: size.width * 0.05,
        ),
        ButtonIconCPNT.image(image: images[1],
          size: Size(size.width * 0.3, size.height),
          onPressed: () {
            _launchInBrowser(_launchGithub);
          },),
        SizedBox(
          width: size.width * 0.05,
        ),
        ButtonIconCPNT.image(image:images[2],
          size: Size(size.width * 0.3, size.height),
          onPressed: () {
            _launchInBrowser(_launchTwitter);
          },),
      ],
    );
  }
}
