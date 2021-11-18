import 'package:flutter/material.dart';
import 'package:recollar/models/user.dart';
import 'package:recollar/screens/my_collections/my_collections.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:recollar/screens/profile/profile.dart';
import 'package:recollar/screens/search/search.dart';
import 'package:recollar/util/configuration.dart';
class AppMain extends StatefulWidget {
  const AppMain({Key? key}) : super(key: key);

  @override
  _AppMainState createState() {
    return _AppMainState();}
}

class _AppMainState extends State<AppMain> with SingleTickerProviderStateMixin{

  List<Widget> screens=[const MyCollections(),const Search(),const Profile()];
  int _currentIndex=0;
  bool _reverse=false;

  Size sizeP=const Size(1,1);
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sizeP=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorGray,
      resizeToAvoidBottomInset: false,


      body: Stack(
        children: [
          SlideTransition(position: Tween<Offset>(
            begin: Offset.zero,
            end: _reverse?const Offset(-1.5, 0.0):const Offset(1.5, 0),
          ).animate(CurvedAnimation(
            parent: _controller,
            curve: Curves.linear,
          )),
            child: IndexedStack(
              children: screens,
              index: _currentIndex,
            ),

          ),

          Positioned(
            bottom: 0,
            child: Container(
              width: sizeP.width-30,
              decoration: BoxDecoration(
                color: colorWhite,

                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1),
                  )
                ],
              ),
              margin:  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(20),
                child: GNav(
                  tabBorderRadius: 20,
                  gap: 8,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  duration: const Duration(milliseconds: 100),
                  color: Colors.grey[800],
                  activeColor: colorBlack,
                  iconSize: 24,
                  tabBackgroundColor: color1.withOpacity(0.7),
                  padding: EdgeInsets.symmetric( vertical: 8,horizontal: sizeP.width*0.05),
                  tabMargin: EdgeInsets.symmetric(vertical: sizeP.height*0.01),
                  onTabChange: (int index)async {
                    /*controller.animateToPage(index,curve: Curves.fastOutSlowIn,duration: const Duration(milliseconds: 300));*/
                    if(index!=_currentIndex){
                      if(_currentIndex>index){
                        setState(() {
                          _reverse=true;
                        });
                      }
                      else{
                        setState(() {
                          _reverse=false;
                        });
                      }
                      await _controller.forward(from: 1.5);
                      setState(() {
                        _currentIndex=index;
                      });
                      await _controller.reverse();
                    }
                  },
                  tabs:  [
                    GButton(
                      iconColor: color2,
                      iconActiveColor: color2,
                      icon: Icons.home,
                      textStyle:  TextStyle(color: color2,fontWeight: FontWeight.w600),
                      text: 'Inicio',
                    ),
                    GButton(
                      iconColor: color2,
                      iconActiveColor: color2,
                      icon: Icons.search,
                      textStyle:  TextStyle(color: color2,fontWeight: FontWeight.w600),
                      text: 'Buscar',
                    ),
                    GButton(
                      iconColor: color2,
                      iconActiveColor: color2,
                      icon: Icons.person,
                      textStyle:  TextStyle(color: color2,fontWeight: FontWeight.w600),
                      text: 'Perfil',
                    )
                  ],

                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
