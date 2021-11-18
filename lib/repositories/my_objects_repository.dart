import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recollar/models/object.dart';
import 'package:recollar/models/object_request.dart';
import 'package:recollar/models/object_simple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as image;
class MyObjectsRepository{
  List<ObjectSimple> objects=[];
  int idCollection=0;
  Object ? object;
  String imageARAux="asdf";
  addObject(ObjectRequest objectRequest,XFile ?imageFile,Uint8List ?imageAR)async{
    objectRequest.idCollection=idCollection;

    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= prefs.getString("token");
    if(token==null){
      throw "No existe token Almacenado";
    }
    var res=await http.post(
        Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/object"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(objectRequest.toJson())
    );
    if(res.statusCode!=200){
      throw "No se pudo agregar la coleccion";
    }
    else{
      var body=jsonDecode(res.body);
      if(!objectRequest.ar){
        await uploadImages(imageFile!, body["idObject"]);
      }
      else{
        await uploadImagesBytes(imageAR!, body["idObject"]);
      }
    }
  }
  updateObject(ObjectRequest objectRequest,XFile ? imageFile,Uint8List ?imageAR)async{
    objectRequest.idCollection=idCollection;

    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= prefs.getString("token");
    if(token==null){
      throw "No existe token Almacenado";
    }
    var res=await http.put(
        Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/object"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(objectRequest.toJson())
    );
    if(res.statusCode!=200){
      throw "No se pudo agregar la coleccion";
    }
    else{
      if(imageFile!=null){
        await uploadImages(imageFile, objectRequest.idObject);
      }
      if(imageAR!=null){
        await uploadImagesBytes(imageAR, objectRequest.idObject);
      }
    }
  }
  Future<void> getObjects(bool init )async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ?token = prefs.getString("token");
    if (token == null) {
      throw "No existe token Almacenado";
    }
    var res = await http.get(
      Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/object",{"id_collection":idCollection.toString()}),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode != 200) {
      throw "No se pudo obtener los objetos";
    }
    else {
      if (init) {
        objects = [];
      }
      var body = json.decode(utf8.decode(res.bodyBytes));

      for (var obj in body) {
        objects.add(ObjectSimple.fromJson(obj, token));
      }
    }
  }
  Future<void> getObjectById(int idObject)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ?token = prefs.getString("token");
    if (token == null) {
      throw "No existe token Almacenado";
    }
    var res = await http.get(
      Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/object/$idObject",),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode != 200) {
      throw "No se pudo obtener el objeto";
    }
    else {

      object=Object.fromJson(json.decode(utf8.decode(res.bodyBytes)),token);
    }
  }
  deleteObject(int idObject)async{

    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= prefs.getString("token");
    if(token==null){
      throw "No existe token Almacenado";
    }
    var res=await http.delete(
      Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/object/$idObject"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if(res.statusCode!=200){
      throw "No se pudo eliminar la coleccion";
    }
  }
  changeStatus(int idObject,int statusObject)async{

    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= prefs.getString("token");
    if(token==null){
      throw "No existe token Almacenado";
    }
    var res=await http.patch(
      Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/object/change-status",{"idObject":idObject.toString(),"objectStatus":statusObject.toString()}),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if(res.statusCode!=200){
      throw "No se pudo cambiar el estado";
    }
  }
  uploadImagesBytes(Uint8List imageFile,idObject)async{
    print("iamgen"+imageFile.toString());


    var uri = Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/object/image",{"idObject":idObject.toString()});


    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= prefs.getString("token");
    var request = http.MultipartRequest('PUT', uri)
      ..fields['idObject'] = idObject.toString()
      ..headers["Authorization"]="Bearer "+(token??"");
    http.MultipartFile imagenMulti;
    imagenMulti=http.MultipartFile.fromBytes("images", imageFile,
      filename: 'resized_image.png',
      contentType: MediaType.parse('image/png'),);
    request.files.add(imagenMulti);
    var response = await request.send();
    print(request.url);
    if(response.statusCode==200){
    }
    else{
      throw "No se pudo subir la imagen de la colleccion";
    }

  }
  uploadImages(XFile imageFile,idObject)async{


    var uri = Uri.http(dotenv.env['API_URL'] ?? "", "${dotenv.env['API_URL_COMP'] ?? ""}/object/image",{"idObject":idObject.toString()});


    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= prefs.getString("token");
    var request = http.MultipartRequest('PUT', uri)
      ..fields['idObject'] = idObject.toString()
      ..headers["Authorization"]="Bearer "+(token??"");
    http.MultipartFile imagenMulti;
      image.Image? imageTemp = image.decodeImage(File(imageFile.path).readAsBytesSync());
      var imgResize=image.copyResize(imageTemp!,width: 500,height: 500);
      imagenMulti=http.MultipartFile.fromBytes("images", image.encodeJpg(imgResize),
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
  removeBgImage(XFile imageFile) async{
    var uri = Uri.https("api.remove.bg", "/v1.0/removebg");


    SharedPreferences prefs=await SharedPreferences.getInstance();
    String ?token= dotenv.env['API_IMAGE_TOKEN'];
    var request = http.MultipartRequest('POST', uri)
      ..fields['size'] = "preview"
      ..fields['crop'] = "true"
      ..headers["X-API-Key"]=(token??"");
    image.Image? imageTemp = image.decodeImage(File(imageFile.path).readAsBytesSync());
    var imgResize=image.copyResize(imageTemp!,width: 1000,height: 1000);
    var imagenMulti=http.MultipartFile.fromBytes("image_file", image.encodeJpg(imgResize),
      filename: 'resized_image.jpg',
      contentType: MediaType.parse('image/jpeg'),);
    request.files.add(imagenMulti);
    var response = await request.send();
    if(response.statusCode==200){
        return await response.stream.toBytes();

    }
    else{
      print(await response.statusCode);
      throw "No se pudo tratar la imagen";
    }
  }

}