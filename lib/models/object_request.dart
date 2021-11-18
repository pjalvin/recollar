class ObjectRequest{
  int ? idObject;
  int ? idCollection;
  String name;
  String description;
  int objectStatus;
  double price;
  bool ar;


  ObjectRequest(this.idObject, this.idCollection, this.name, this.description,
      this.objectStatus, this.price,this.ar);

  Map <String,dynamic> toJson()=>{
    "idObject":idObject,
    "idCollection": idCollection,
    "name": name,
    "description": description,
    "objectStatus": objectStatus,
    "price": price,
    "ar":ar
  };
}