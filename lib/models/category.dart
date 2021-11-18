class Category{
  int idCategory;
  String name;
  Category.fromJson(json):
      idCategory=json["idCategory"],
      name=json["name"];
}