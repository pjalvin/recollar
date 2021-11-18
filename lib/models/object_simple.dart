

class ObjectSimple{
  int idObject;
  String image;
  String name;
  String token;
  bool ar;
  bool tools=false;

ObjectSimple.fromJson(json,this.token):
        idObject=json["idObject"],
        name=json["name"],
        ar=json["ar"],
        image=json["image"];

}