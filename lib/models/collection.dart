import 'package:flutter/cupertino.dart';

class Collection{
  int idCollection;
  String image;
  String name;
  int amount;
  String token;
  int idCategory;
  bool tools=false;

  Collection.fromJson(json,this.token):
        idCollection=json["idCollection"],
        image=json["image"]??"",
        name=json["name"],
        idCategory=json["idCategory"],
        amount=json["amount"];


}