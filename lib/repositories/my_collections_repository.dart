import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recollar/models/category.dart';
import 'package:recollar/models/collection.dart';
import 'package:recollar/models/collection_request.dart';
import 'package:recollar/models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as image;
class MyCollectionsRepository{
  List<Collection> collections=[];
  List<Category> categories=[];
  Future<void> getCollections({required bool init})async{

    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= prefs.getString("token");
    if(token==null){
      throw "No existe token Almacenado";
    }
    var res=await http.get(
      Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/collection"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if(res.statusCode!=200){
      print(res.body);
      print(res.request!.url);
      print(token);
      throw "No se pudo obtener las colecciones";
    }
    else{
      if(init){
        collections=[];
      }
      var body = json.decode(utf8.decode(res.bodyBytes));

      for(var col in body){
        collections.add(Collection.fromJson(col, token));
      }
    }
  }
  addCollection(CollectionRequest collectionRequest,XFile imageFile)async{

    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= prefs.getString("token");
    if(token==null){
      throw "No existe token Almacenado";
    }
    var res=await http.post(
      Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/collection"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(collectionRequest.toJson())
    );
    if(res.statusCode!=200){
      throw "No se pudo agregar la coleccion";
    }
    else{
      print(res.body);
      var body=jsonDecode(res.body);
      await uploadImages(imageFile, body["idCollection"]);
    }
  }
  updateCollection(CollectionRequest collectionRequest,XFile ? imageFile)async{

    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= prefs.getString("token");
    if(token==null){
      throw "No existe token Almacenado";
    }
    var res=await http.put(
        Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/collection"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(collectionRequest.toJson())
    );
    if(res.statusCode!=200){
      throw "No se pudo editar la coleccion";
    }
    else{
      if(imageFile!=null){
        await uploadImages(imageFile, collectionRequest.idCollection);
      }
    }
  }
  deleteCollection(int idCollection)async{

    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= prefs.getString("token");
    if(token==null){
      throw "No existe token Almacenado";
    }
    var res=await http.delete(
        Uri.http(dotenv.env['API_URL'] ?? "","${dotenv.env['API_URL_COMP'] ?? ""}/collection/$idCollection"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
    );
    if(res.statusCode!=200){
      throw "No se pudo eliminar la coleccion";
    }
  }
  Future<void> getCategories()async{

    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= prefs.getString("token");
    if(token==null){
      throw "No existe token Almacenado";
    }
    var res=await http.get(
      Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/category"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if(res.statusCode!=200){
      throw "No se pudo obtener las categorias";
    }
    else{
      print(res.body);
      categories=[];
      var body = json.decode(utf8.decode(res.bodyBytes));

      for(var cat in body){
        categories.add(Category.fromJson(cat));
      }
    }
  }
  uploadImages(XFile imageFile,idCollection)async{


      var uri = Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/collection/image",{"idCollection":idCollection.toString()});


      SharedPreferences prefs=await SharedPreferences.getInstance();
      String ?token= prefs.getString("token");
      var request = http.MultipartRequest('PUT', uri)
        ..fields['idCollection'] = idCollection.toString()
        ..headers["Authorization"]="Bearer "+(token??"");
      image.Image? imageTemp = image.decodeImage(File(imageFile.path).readAsBytesSync());
      var imgResize=image.copyResize(imageTemp!,width: 500,height: 500);
      var imagenMulti=http.MultipartFile.fromBytes("images", image.encodeJpg(imgResize),
        filename: 'resized_image.jpg',
        contentType: MediaType.parse('image/jpeg'),);
      request.files.add(imagenMulti);
      var response = await request.send();
      print(request.url);
      if(response.statusCode==200){
      }
      else{
        throw "No se pudo subir la imagen de la colleccion";
      }

  }


}