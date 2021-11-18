import 'package:flutter/material.dart';
import 'package:recollar/general_widgets/text_subtitle_cpnt.dart';
import 'package:recollar/models/combo_box_item.dart';
import 'package:recollar/util/configuration.dart';
import 'package:recollar/util/my_behavior.dart';

class ComboBoxPrimaryCPNT extends StatefulWidget {
  VoidCallback  ?onPressed;
  Size size;
  Color colorBg;
  Color colorBorder;
  Color colorText;
  String hintText;
  ComboBoxItem comboBoxItem;
  List<ComboBoxItem> items;
  ComboBoxPrimaryCPNT({Key? key,required this.comboBoxItem,required this.items,this.onPressed,required this.colorBorder,required this.size,required this.colorBg,required this.colorText,required this.hintText}) : super(key: key);

  @override
  State<ComboBoxPrimaryCPNT> createState() => _ComboBoxPrimaryCPNTState();
}

class _ComboBoxPrimaryCPNTState extends State<ComboBoxPrimaryCPNT> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        minWidth: widget.size.width,
        padding: const EdgeInsets.all(0),
        height: widget.size.height,
        onPressed:(){
          changeItem(context);
        },
        color: widget.colorBg,
        elevation: 0,
        shape: RoundedRectangleBorder(side:  BorderSide(color: widget.colorBorder,width: 1)),
        child: SizedBox(
          width: widget.size.width*0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextSubtitleCPNT(colorText: widget.comboBoxItem.name!=null?color2:color2.withOpacity(0.5), text: widget.comboBoxItem.name??widget.hintText, weight: FontWeight.w600),
              Icon(Icons.arrow_drop_down, color: color2,)
            ],
          ),
        )
      );
  }
  changeItem(context){
    print(widget.items.length);
    Size size;
    showModalBottomSheet(context: context,isDismissible: false, builder: (context){
      size=MediaQuery.of(context).size;
      return Container(
        height: 50.0+50.0*widget.items.length>size.height*0.5?size.height*0.5:50.0+50.0*widget.items.length,
        color: color3.withOpacity(0.1),
        child: Column(
          children: [
            Container(
              width: size.width,
              margin: EdgeInsets.symmetric(horizontal: size.width*0.02),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: color2,))
              ),
              height: 50,
              alignment: Alignment.center,
              child:
              TextSubtitleCPNT(text: widget.hintText,weight: FontWeight.w600,colorText: color2,),
            ),
           Expanded(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child:ListView.builder(
                        itemCount: widget.items.length,
                        itemBuilder: (context,index){
                          return MaterialButton(
                              height: 50,
                              focusElevation: 0,
                              highlightElevation: 0,
                              hoverElevation: 0,
                              elevation: 0,
                              onPressed: (){
                                setState(() {
                                  widget.comboBoxItem.name=widget.items[index].name;
                                  widget.comboBoxItem.id=widget.items[index].id;
                                  Navigator.pop(context);

                                  FocusScope.of(context).unfocus();
                                });},
                              child: Text(widget.items[index].name??"",style: TextStyle(color: color2),),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

