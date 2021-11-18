class CollectionRequest{
  int ? idCollection;
  String name;
  int idCategory;

  CollectionRequest(this.idCollection, this.name, this.idCategory);
  Map <String,dynamic> toJson()=>{
    "idCollection":idCollection,
    "name":name,
    "idCategory":idCategory,
  };
}